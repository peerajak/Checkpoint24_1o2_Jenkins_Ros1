# Checkpoint24_1o2_Jenkins_Ros1

## Quick guide

## Jenkins



## Build and run dockers manually

build docker 

```
docker build -t tortoisebot-waypoints-test:v1 .
```

Terminal 1 Roscore and Gazebo

```
docker context use default
xhost +local:root
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --gpus all --net=host tortoisebot-waypoints-test:v1 
```


