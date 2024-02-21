#!/bin/bash

### steps ####
# verify the system has a cuda-capable gpu
# download and install the nvidia cuda toolkit and cudnn
# setup environmental variables
# verify the installation
###

### to verify your gpu is cuda enable check
lspci | grep -i nvidia

### If you have previous installation remove it first. 
#dpkg -l | grep cuda
#dpkg -l | grep nvidia
#sudo apt remove --purge "cublas*" "cuda*" "nvidia*" -y
sudo apt remove --purge *cuda* -y
sudo apt remove --purge *nvidia* -y
sudo rm /etc/apt/sources.list.d/cuda*
sudo rm -rf /usr/local/cuda*
sudo apt autoremove -y
sudo apt autoclean -y

# system update
sudo apt update
sudo apt upgrade

# install other import packages
sudo apt install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y

# first get the PPA repository driver
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

# install nvidia driver with dependencies
sudo apt install libnvidia-common-545 -y
sudo apt install libnvidia-gl-545 -y
sudo apt install nvidia-driver-545 -y

# start to install cuda 11.7
cd ~/Downloads
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
sudo apt update
sudo apt full-upgrade -y
# installing CUDA-11.7
sudo apt install cuda-11-7 -y

# setup your paths
echo 'export PATH=$PATH:/usr/local/cuda-11.7/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.7/lib64' >> ~/.bashrc
source ~/.bashrc
sudo ldconfig

# install cuDNN v8.5.0
# First register here: https://developer.nvidia.com/developer-program/signup

wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.5.0/local_installers/11.7/cudnn-linux-x86_64-8.5.0.96_cuda11-archive.tar.xz
tar -xvf cudnn-linux-x86_64-8.5.0.96_cuda11-archive.tar.xz

# copy the following files into the cuda toolkit directory.
sudo cp -P cudnn-linux-x86_64-8.5.0.96_cuda11-archive/include/cudnn.h /usr/local/cuda-11.7/include
sudo cp -P cudnn-linux-x86_64-8.5.0.96_cuda11-archive/lib/libcudnn* /usr/local/cuda-11.7/lib64/
sudo chmod a+r /usr/local/cuda-11.7/lib64/libcudnn*

# reboot
sudo reboot now

# Finally, to verify the installation, check
nvidia-smi
nvcc -V

# install Pytorch (an open source machine learning framework)
# https://pytorch.org/get-started/previous-versions/
#pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117
