# Checkpoint24_1o2_Jenkins_Ros1

## Quick guide

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

299263e4d7c34fb9b85d689ae603fda5
```

The number at the position of "299263e4d7c34fb9b85d689ae603fda5" is the password. Copy that to clip board, and paste this into password input box in the jenkins website.

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
docker build -t tortoisebot-waypoints-test:v1 .
```

Repeat the add build step with the following code

```
docker context use default
xhost +local:root
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot-waypoints-test:v1 
```

Finally Click Save

Build the project

![alt text](Jenkins_website_a6_00.png)

See a succesful result

![alt text](Jenkins_website_a7_00.png)

Build the project again, this time check the gazebo, you should see the robot moving to the testing waypoint

![alt text](Jenkins_website_a7_01.png)


### Step 3. Automate the test process on each Git push, pull request


--- end Jenkins -----

## Build and run dockers manually

In this section, more details about how to build an run docker is written.

build docker 

```
docker build -t tortoisebot-waypoints-test:v1 .
```

- Running on the construct's computer

```
docker context use default
xhost +local:root
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot-waypoints-test:v1 
```
- Running on my Local computer

```
docker context use default
xhost +local:root
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --gpus all --net=host tortoisebot-waypoints-test:v1 
```


