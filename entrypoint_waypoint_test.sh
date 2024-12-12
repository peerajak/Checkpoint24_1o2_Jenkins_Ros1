#! /bin/bash 

source /tortoisebot_ws/devel/setup.bash

### Method 1 #### Call waypoint_test with rosrun
## 1. call gazebo
#echo "$(date +'[%Y-%m-%d %T]') Starting gazebo..."
#roslaunch tortoisebot_gazebo tortoisebot_playground.launch &
#sleep 6

## 2. Start Waypoint Server
#echo "$(date +'[%Y-%m-%d %T]') Starting waypoint action server..." 
#rosrun tortoisebot_waypoints tortoisebot_action_server.py &
#sleep 6

## 3. Start Waypoint tester
#echo "$(date +'[%Y-%m-%d %T]') Starting waypoint action server tester..." 
#rosrun tortoisebot_waypoints waypoints_test.py


###  Method 2 #### Call Rostest

# 1. call gazebo
echo "$(date +'[%Y-%m-%d %T]') Starting gazebo..."
roslaunch tortoisebot_gazebo tortoisebot_playground.launch &
sleep 6

# 2. Use rostest to start Waypoint Server and waypoints_test
echo "$(date +'[%Y-%m-%d %T]') Starting rostest..." 
rostest tortoisebot_waypoints waypoints_test.test --reuse-master
