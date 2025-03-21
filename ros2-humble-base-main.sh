#!/usr/bin/env bash
set -eu

CHOOSE_ROS_DISTRO=humble
INSTALL_PACKAGE=ros-base
TARGET_OS=jammy

# Check OS version
if ! which lsb_release > /dev/null ; then
	sudo apt-get update
	sudo apt-get install -y curl lsb-release
fi

if ! dpkg --print-architecture | grep -q 64; then
	printf '\033[33m%s\033[m\n' "=================================================="
	printf '\033[33m%s\033[m\n' "ERROR: This architecture ($(dpkg --print-architecture)) is not supported"
	printf '\033[33m%s\033[m\n' "See https://www.ros.org/reps/rep-2000.html"
	printf '\033[33m%s\033[m\n' "=================================================="
	exit 1
fi

printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Updating your Ubuntu 22.05           |"
printf '\033[33m%s\033[m\n' "=================================================="

sudo apt update && sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Get ROS 2 Humble key                 |"
printf '\033[33m%s\033[m\n' "=================================================="

sudo apt install -y software-properties-common 
sudo add-apt-repository -y universe
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null


printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Install ROS 2 Humble                 |"
printf '\033[33m%s\033[m\n' "=================================================="

sudo apt update 
sudo apt install -y ros-humble-ros-base
sudo apt install -y ros-dev-tools

printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Install ROS dependencie              |"
printf '\033[33m%s\033[m\n' "=================================================="

sudo apt install -y libserial-dev ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-xacro ros-humble-joint-state-publisher-gui ros-humble-robot-localization ros-humble-joy ros-humble-joy-teleop ros-humble-tf-transformations ros-humble-gazebo-ros2-control ros-humble-joint-state-broadcaster ros-humble-velocity-controllers ros-humble-diff-driver-controller
pip install smbus

printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Update Environment Variables         |"
printf '\033[33m%s\033[m\n' "=================================================="


grep -F "source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash" ~/.bashrc ||
echo "source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash" >> ~/.bashrc

grep -F "export ROS_DOMAIN_ID=30" ~/.bashrc ||
echo "export ROS_DOMAIN_ID=30" >> ~/.bashrc


printf '\033[33m%s\033[m\n' "=================================================="
printf '\033[33m%s\033[m\n' "|           Pulling BabyBot         |"
printf '\033[33m%s\033[m\n' "=================================================="

cd ~
git clone http://github.com/twming/babybot

set +u

source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash

echo "success installing ROS2 $CHOOSE_ROS_DISTRO"
echo "Run 'source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash'"
