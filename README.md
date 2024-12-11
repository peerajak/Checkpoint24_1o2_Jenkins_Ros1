# Checkpoint24_1o2_Jenkins_Ros1

## Quick guide

1. install docker

```
cd 
./course_install.sh
```
To make docker run on user without sudo

```
sudo groupadd docker
sudo usermod -aG docker $USER
sudo gpasswd -a $USER docker
newgrp docker
```

2. start jenkins

```
cd ~/webpage_ws
./start_jenkins.sh
```

The 3 latest output of start_jenkins.sh should show the following data
- jenkins website
- password
- webhook

3. Copy webhook address to clipboard, and paste it at your github repository

![alt text](Jenkins_website_79_04.png)


4. sign in jenkins

5. copy ssh_config to ~/.ssh/config

```
cd /home/user/catkin_ws/src/ros1_ci
cp ssh_config ~/.ssh/config
```

6. Generate two ssh keys

```
cd ~/webpage_ws
bash setup_ssh_git.sh
bash setup_2nd_ssh_git.sh
rm ~/.ssh/known_hosts
```

7. create jenkins user credential for both project
8. change deploy key on Github for both projects
9. config git source for both projects.


## Jenkins

There are 3 steps

- Install Jenkins
- Create a Jenkins pipeline for automating the test process
- Automate the test process on each Git push, pull request

### Step 1 Install Jenkins
Terminal 1

```
cd ~/webpage_ws
./start_jenkins.sh | grep URL
```
Copy the URL address starting from "https://" to the end of the line, and paste to browser, or alternatively, place ctrl while click on the word "https"

Go to web browser, with corresponding site. From now on this web browser, with this address, will be called Jenkins website.

Open the file ~/webpage_ws/jenkins_installation_log.log looks for something like

```
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

211113e4d7111111185d689111113fda5
```

The number at the position of "211113e4d7111111185d689111113fda5" is the password. Copy that to clip board, and paste this into password input box in the jenkins website.

![alt text](Jenkins_website_01_00.png)
![alt text](Jenkins_website_02_00.png)
![alt text](Jenkins_website_03_00.png)
![alt text](Jenkins_website_04_00.png)
![alt text](Jenkins_website_05_00.png)
![alt text](Jenkins_website_06_00.png)
Finally a working jenkin website. Later will be call dashboard, as you can see there is a word dashboard in the image.
![alt text](Jenkins_website_07_00.png)

If you happen to get to the dashbord image without installing procedures before, just do the next step.

### Step 2. Create a Jenkins pipeline for automating the test process

Install all required plugin 

![alt text](Jenkins_website_61_00.png)
![alt text](Jenkins_website_71_00.png)
![alt text](Jenkins_website_72_00.png)

Add new pipeline, name it ros1_ci as shown in the image

![alt text](Jenkins_website_a1_00.png)
![alt text](Jenkins_website_a2_00.png)
![alt text](Jenkins_website_a3_00.png)
![alt text](Jenkins_website_a4_00.png)

Place the following script into the box shown in image and click add build step

```
#!/bin/bash
cd /home/user/catkin_ws/src
echo "Will check if we need to clone or just pull"
if [ ! -d "ros1_ci" ]; then
  git clone https://github.com/peerajak/Checkpoint24_1o2_Jenkins_Ros1.git ros1_ci
else
  cd ros1_ci
  git pull origin main
fi
```
![alt text](Jenkins_website_a5_00.png)

Repeat the add build step with the following code

```
cd /home/user/catkin_ws/src/ros1_ci
docker pull peerajakcp22/tortoisebot-waypoints-ros1-test:v1
```

Repeat the add build step with the following code

```
docker context use default
xhost +local:root
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix peerajakcp22/tortoisebot-waypoints-ros1-test:v1
```

Finally Click Save

Build the project

![alt text](Jenkins_website_a6_00.png)

See a succesful result

![alt text](Jenkins_website_a7_00.png)

Build the project again, this time check the gazebo, you should see the robot moving to the testing waypoint

![alt text](Jenkins_website_a7_01.png)


### Step 3. Automate the test process on each Git push, pull request

```
cd ~/webpage_ws
bash setup_ssh_git.sh
cat /home/user/.ssh/id_rsa.pub
```

The result should look like this

```
ssh-rsa AAAAverylongverylongverylongrZvdLcpOlhE0=
```

Add Deploy key. Deploy Key allows Jenkins to query changes in Github repository
Go to github repository of your project, press setting

![alt text](Jenkins_website_73_00.png)

then

![alt text](Jenkins_website_74_00.png)
![alt text](Jenkins_website_75_00.png)
![alt text](Jenkins_website_76_00.png)
![alt text](Jenkins_website_77_00.png)

then at Jenkin Website

![alt text](Jenkins_website_78_00.png)
![alt text](Jenkins_website_79_00.png)
![alt text](Jenkins_website_79_01.png)
![alt text](Jenkins_website_79_02.png)

on a Terminal, do

```
cat /home/user/.ssh/id_rsa
```

you should get the result like this

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEAnv9x3x38Is9wsYt1MhU4+awxoTiM9vf01j9zpKmQnlEoNyP7K5EI
C3tduQ/HZTJ9cUpTrwBzLXTO1fep4KgwJZ5alvU7aPptBHTFXzVNGIM3NzwYqwnXJ0xDIk
vckBBOLe33lISB129erY7SysSVWE38+sE7fDg1sJIRGu808ZT65fVxuhlSl7utRGHRYrmY
T7KJ6kDR3XBhC427dAJaFQYNs/zVLv4jUlsXwCGmpoQ9HE9NQT3pWWcD9CO+7eus9+thqM
5WBbOrSXJaXrum96p0vq6QwOpgG88PIDwJc1nvn2+Z6cMF8IlTDEfAS1Q2SoKz01QxYz3A
To+u53bSqYP4sAAAAAAQID
-----END OPENSSH PRIVATE KEY-----
```

Copy this result starting with -----Begin ending with END OPENSSH PRIVATE KEY-----, and place it to the Jenken website Key Box
Then Click Create.

![alt text](Jenkins_website_79_03.png)

Create a Webhook

at a Terminal, do

```
echo "$(jenkins_address)github-webhook/"
```
![alt text](Jenkins_website_79_04.png)
![alt text](Jenkins_website_79_05.png)
![alt text](Jenkins_website_79_06.png)
![alt text](Jenkins_website_79_07.png)
![alt text](Jenkins_website_79_08.png)
![alt text](Jenkins_website_79_09.png)
![alt text](Jenkins_website_79_10.png)
![alt text](Jenkins_website_79_11.png)

If there is an error at the git source box, saying something like "ECDSA key error", check the CLI, if there is an additional message on CLI asking, then

```
The authenticity of host 'github.com (20.205.243.166)' can't be established.
ECDSA key fingerprint is SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com,20.205.243.166' (ECDSA) to the list of known hosts.
```
Anwser is 'Y'

To test the webhook, on a Terminal

```
touch tmp.txt
echo "some random text" >> tmp.txt
git add tmp.txt
git commit -m "add tmp.txt for just updating, but I am waiting to see Jenkin webhook to build"
git push origin master
```
You should see the following, with some clicks.

![alt text](Jenkins_website_79_12.png)
![alt text](Jenkins_website_79_13.png)
![alt text](Jenkins_website_79_14.png)
![alt text](Jenkins_website_79_15.png)
![alt text](Jenkins_website_a7_01.png)

Create a pull Reqeust

1. add a text to main branch
2. commit, and push main branch
3. create pull request by comparing main branch to master branch
4. accept the pull request
5. See that the webhook call Jenkins to build the docker to test the waypoint action server.

![alt text](Jenkins_website_79_16.png)
![alt text](Jenkins_website_79_17.png)
![alt text](Jenkins_website_79_18.png)
![alt text](Jenkins_website_79_19.png)
![alt text](Jenkins_website_a7_01.png)

--- end Jenkins -----

## Build and run dockers manually

In this section, more details about how to build an run docker is written.

build docker 

```
docker build -t tortoisebot-waypoints-ros1-test:v1 .
```

```
docker tag tortoisebot-waypoints-ros1-test:v1 peerajakcp22/tortoisebot-waypoints-ros1-test:v1
docker push peerajakcp22/tortoisebot-waypoints-ros1-test:v1
```

- Running on the construct's computer

```
docker context use default
xhost +local:root
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot-waypoints-ros1-test:v1 
```
- Running on my Local computer

```
docker context use default
xhost +local:root
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --gpus all --net=host tortoisebot-waypoints-ros1-test:v1 
```


## Trouble shooting

if jenkins error at github source saying 

```
Failed to connect to repository : Command "git ls-remote -h -- git@github.com:peerajak/Checkpoint24_2o2_Jenkins_Ros2.git HEAD" returned status code 128:
stdout:
stderr: No ECDSA host key is known for github.com and you have requested strict checking.
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

open a terminal and

```
git ls-remote -h -- git@github.com:peerajak/Checkpoint24_2o2_Jenkins_Ros2.git HEAD
```

answer yes.