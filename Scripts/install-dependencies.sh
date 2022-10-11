#!/bin/bash
#
# Script to install the dependencies in order to run the UVtools
# Can be run outside UVtools and as standalone script
# Then run this script
# usage 1: sudo ./install-dependencies.sh 
#

echo "Script to install the dependencies in order to run the UVtools"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

arch_name="$(uname -m)"
osVariant=""

if [[ "$arch_name" != "x86_64" && "$arch_name" != "arm64" ]]; then
    echo "Error: Unsupported host arch: $arch_name"
    exit -1
fi

#echo "- Detecting OS"
if [[ $OSTYPE == 'darwin'* ]]; then
    osVariant="macOS"
    #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    #brew analytics off
    #brew install git cmake mono-libgdiplus
    #brew install --cask dotnet
elif command -v apt-get &> /dev/null
then
    osVariant="debian"
    apt-get update
    apt-get install -y libdc1394-22 libopenexr24
	apt-get install -y libdc1394-25 libopenexr25
	apt-get install -y libjpeg-dev libpng-dev libgeotiff-dev libgeotiff5 libavcodec-dev libavformat-dev libswscale-dev libtbb-dev libgl1-mesa-dev libgdiplus wget
elif command -v pacman &> /dev/null
then
    osVariant="arch"
    pacman -Syu
    pacman -S openjpeg2 libjpeg-turbo libpng libgeotiff libdc1394 ffmpeg openexr tbb libgdiplus wget
elif command -v yum &> /dev/null
then
    osVariant="rhel"
    yum update -y
    yum install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    yum install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    yum install -y libjpeg-devel libjpeg-turbo-devel libpng-devel libgeotiff-devel libdc1394-devel ffmpeg-devel tbb-devel mesa-libGL wget
fi

if [ "$osVariant" == "" ]; then
    echo "Error: Base operative system / package manager not identified, nothing was installed"
else
    echo "Completed: You can now run UVtools"
fi

