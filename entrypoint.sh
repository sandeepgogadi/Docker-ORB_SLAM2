#!/bin/bash

cd /ORB_SLAM2/
git pull
source ~/.bashrc
export ROS_PACKAGE_PATH=/opt/ros/kinetic/share:/ORB_SLAM2/Examples/ROS
cd /ORB_SLAM2 && source ~/.bashrc && chmod +x build_ros.sh && ./build_ros.sh

/bin/bash
