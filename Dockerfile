FROM ros:noetic-ros-core-focal

# Change the default shell to Bash
SHELL [ "/bin/bash" , "-c" ]


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git ros-noetic-rviz ros-noetic-compressed-image-transport ros-noetic-joy ros-noetic-teleop-twist-joy ros-noetic-teleop-twist-keyboard ros-noetic-amcl ros-noetic-map-server ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro ros-noetic-rqt-image-view ros-noetic-gmapping ros-noetic-navigation ros-noetic-joint-state-publisher ros-noetic-robot-state-publisher ros-noetic-slam-gmapping ros-noetic-dwa-local-planner ros-noetic-joint-state-publisher-gui  ros-noetic-gazebo-ros-pkgs ros-noetic-gazebo-ros-control && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3-rosdep python-is-python3 

# Install python 3.7
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.7 -y

# Make python 3.7 the default
RUN echo "alias python=python3.7" >> /root/.bashrc
RUN export PATH=${PATH}:/usr/bin/python3.7
RUN /bin/bash -c "source /root/.bashrc"


# Create a Catkin workspace and clone Tortoisebot repos
RUN source /opt/ros/noetic/setup.bash \
 && mkdir -p /tortoisebot_ws/src \
 && cd /tortoisebot_ws/src \
 && catkin_init_workspace 
RUN cd /tortoisebot_ws/src && git clone -b noetic https://github.com/rigbetellabs/tortoisebot.git 

# Clone tortoisebot_waypoints package to /tortoisebot_ws/src
RUN cd /tortoisebot_ws/src && git clone https://github.com/peerajak/Checkpoint23_1o2_PythonROS1.git tortoisebot_waypoints

# Build the Catkin workspace and ensure it's sourced
RUN source /opt/ros/noetic/setup.bash \
 && cd /tortoisebot_ws \
 && catkin_make
RUN echo "source /tortoisebot_ws/devel/setup.bash" >> ~/.bashrc


# Set the working folder at startup
WORKDIR /tortoisebot_ws

# Copy entrypoint
COPY ./entrypoint_waypoint_test.sh /tortoisebot_ws/entrypoint.sh

# run entryfile.sh
CMD ["/bin/bash", "-c", "/tortoisebot_ws/entrypoint.sh"]
