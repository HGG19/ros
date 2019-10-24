FROM ubuntu:16.04

# Install ros
RUN apt-get update
RUN apt-get -q -y install lsb-core apt-utils git
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update
RUN apt-get -y install ros-kinetic-desktop-full
RUN rosdep init
RUN rosdep update

# Libs
RUN apt-get --assume-yes install libqwt-dev libblas-dev libboost-dev liblapack-dev libarmadillo-dev \
    ros-kinetic-rosserial-arduino ros-kinetic-rosserial ros-kinetic-can-msgs libpcap0.8-dev \
    build-essential software-properties-common python-pip kcachegrind massif-visualizer libmuparser-dev

# Pip dependencies
RUN echo "scipy\n prettytable" > requirements.txt
RUN pip2 install --upgrade pip
RUN pip2 install -r requirements.txt

# ROS
RUN apt-get --assume-yes install ros-kinetic-can-msgs ros-kinetic-velodyne ros-kinetic-geometry2 ros-kinetic-rqt-multiplot \
    ros-kinetic-tf2-sensor-msgs ros-kinetic-jsk-rviz-plugins ros-kinetic-robot-localization \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get -y install gcc-7 g++-7

#!/bin/bash
RUN apt-get -y install ros-kinetic-rosserial-arduino
RUN apt-get -y install ros-kinetic-rosserial
RUN apt-get -y install ros-kinetic-can-msgs
RUN apt-get -y install libpcap0.8-dev

# Installs basler driver dependencies.
# Ignores camera_control_msgs as it is already situated inside the the package.
#RUN rosdep install --from-paths rdv_basler_driver/ --ignore-src rdv_basler_driver/camera_control_msgs/ -y

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
RUN apt-get -yq install docker.io

# Build catkin_simple and gtsam
RUN mkdir -p $JENKINS_HOME/catkin_rdv/src
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash; cd $JENKINS_HOME/catkin_rdv/src; git clone https://github.com/catkin/catkin_simple.git; cd ..; catkin_make;"
RUN /bin/bash -c "cd $JENKINS_HOME/catkin_rdv/src; git clone https://github.com/ethz-asl/gtsam_catkin.git; cd gtsam_catkin; git checkout 4b61d6862b2319367e25f85d1149271063fc2bcd; cd ../..; source /opt/ros/kinetic/setup.bash; catkin_make"



