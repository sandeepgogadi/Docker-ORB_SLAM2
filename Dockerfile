FROM osrf/ros:kinetic-desktop-full

MAINTAINER Sandeep Gogadi <sandeepgogadi@yahoo.com>

### Update all packages
RUN apt-get update \
    && apt-get -y upgrade \
    && rm -rf /var/lib/apt/lists/*

# Replacing shell with bash for later source, catkin build commands
RUN mv /bin/sh /bin/sh-old && \
    ln -s /bin/bash /bin/sh

### Nvidia Driver
LABEL com.nvidia.volumes.needed="nvidia_driver"
### Nvidia path
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

### Source ROS
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

### Install essentials
RUN apt-get update && apt-get install -q -y \
    nano wget sudo\
    python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*

### Gazebo sources and keys
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list' \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

### Gazebo Models
RUN mkdir -p ~/.gazebo/models \
    && hg clone https://bitbucket.org/osrf/gazebo_models ~/.gazebo/models

### Create a Dependencies folder
RUN mkdir Dependencies

### Dependencies
ADD dependencies.sh /dependencies.sh
RUN bash /dependencies.sh

### Install OpenCV 3.2
ADD opencv.sh /opencv.sh
RUN bash /opencv.sh

### Install ORB-SLAM2
RUN git clone https://github.com/sandeepgogadi/ORB_SLAM2 \
    && cd ORB_SLAM2 \
    && chmod +x build.sh \
    && ./build.sh

RUN echo "export ROS_PACKAGE_PATH=/opt/ros/kinetic/share:/ORB_SLAM2/Examples/ROS" >> ~/.bashrc

### Download Data
RUN mkdir data \
    && cd data \
    && wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_xyz.tgz \
    && wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_03_difficult/V1_03_difficult.zip \
    && tar -xvzf rgbd_dataset_freiburg1_xyz.tgz \
    && wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_01_easy/V1_01_easy.bag \
    && rm rgbd_dataset_freiburg1_xyz.tgz \
    && unzip V1_03_difficult.zip \
    && rm V1_03_difficult.zip

### Add entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
