FROM ros:kinetic-ros-base-xenial
# Libs
RUN apt-get update && apt-get install -yq libqwt-dev libblas-dev libboost-dev liblapack-dev libarmadillo-dev \
    ros-kinetic-rosserial-arduino ros-kinetic-rosserial ros-kinetic-can-msgs libpcap0.8-dev \
    build-essential software-properties-common python-pip kcachegrind massif-visualizer libmuparser-dev libpcap0.8-dev ros-kinetic-roslint apt-utils



# ROS dependencies
RUN apt-get --assume-yes install ros-kinetic-can-msgs ros-kinetic-velodyne ros-kinetic-geometry2 ros-kinetic-rqt-multiplot \
    ros-kinetic-tf2-sensor-msgs ros-kinetic-jsk-rviz-plugins ros-kinetic-robot-localization

RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get -y install gcc-7 g++-7

RUN apt-get -y install ros-kinetic-rosserial-arduino
RUN apt-get -y install ros-kinetic-rosserial
RUN apt-get -y install ros-kinetic-can-msgs
RUN apt-get -y install libpcap0.8-dev

# Build catkin_simple and gtsam
RUN mkdir -p /catkin_rdv/src
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash; cd /catkin_rdv/src; git clone https://github.com/catkin/catkin_simple.git; cd ..; catkin_make; rm -rf src/catkin_simple"
#RUN /bin/bash -c "cd /catkin_rdv/src; git clone https://github.com/ethz-asl/gtsam_catkin.git; cd gtsam_catkin; git checkout 4b61d6862b2319367e25f85d1149271063fc2bcd; cd ../..; source /opt/ros/kinetic/setup.bash; catkin_make"

RUN /bin/bash -c "cd ~; git clone https://github.com/borglab/gtsam.git; cd gtsam; git checkout f02aa1bdd804c924d87fb50117df6edb784f639e; mkdir build && cd build; cmake -DGTSAM_USE_SYSTEM_EIGEN=OFF -j4 ..; sudo make install"

RUN apt-get update && apt-get -q -y install lsb-core apt-utils git ssh && apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools libeigen3-dev

RUN rm /etc/ros/rosdep/sources.list.d/20-default.list
RUN rosdep init
RUN rosdep update
