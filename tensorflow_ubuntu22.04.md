# Enable tensorflow GPU on Ubuntu 22.04 (or 20.04)

Here I'm making a note to record/share how I enabled Tensorflow (GPU) on Ubuntu 22.04 (or 20.04).

## Motivation
Recently, I started to use Linux OS (Ubuntu) for my PhD research because of the following reasons:
1) Linux looks intersting and cool.
2) To take advantages of performing a machine learning on Linux OS
3) To get used to programming languages

I first started from WSL2 on Windows 11 at first. I was able to set Tensorflow GPU up after multiple trials, but Tensorflow GPU on WSL2 doesn't provide any benefit compared to that on Windows 11. For some reasons, the initial GPU start-up takes too long and nobody clearly stated/solved the issue. You can find the issue from [here](https://github.com/tensorflow/tensorflow/issues/55067).

So I decided to test genuine Ubuntu. One workstation in my research lab has dual boot Ubuntu 20.04, and I tested Tensorflow 2.3.0 and it perfectly works with GPU driver. Then I moved on to my laptop; I installed Ubuntu 22.04 as dual boot and setup the same environment I did on the workstation - but it failed. I thought it might be Ubuntu 22.04 is not yet supported by Tensorflow, so I re-install Ubuntu 20.04, and it failed again.

After few hours of searching and reinstalling, I found out that nvidia-driver 510, which was recommended version, doesn't recognise the laptop's GPU driver, i.e., RTX 3050 Ti, so I installed nvidia-driver 470 and it worked. May be, I would have stopped here - I was okay, Tensorflow was running on Ubuntu 20.04 with GPU. But I wasn't happy with it because I just wanted to use 22.04 version of Ubuntu.

So I tried again with Ubuntu 22.04 and now, it works! After long hours over the weekend, now I have Tensorflow using my graphics driver on Ubuntu 22.04. And I want to record and share how I did it.

## There are key points to know:
- The nvidia-driver 510 doesn't appear to recognise some GPUs (e.g., RTX 3050 Ti).
- Ubuntu 22.04 uses CUDA 11.5 as default, but CUDA 11.2 is the latest version associated with tensorflow according to the [tensorflow tested build table](https://www.tensorflow.org/install/source).
- This was tested on Ubuntu 20.04 and 22.04, and it worked perfectly on both.

## Machine specification
- DELL-XPS15-9510
- RTX 3050 Ti (Laptop)
- Ubuntu 22.04 (or 20.04) as Dual boot with Windows 11 Pro

## Packages (Python/Tensorflow/CUDA/CuDNN/NVIDIA Driver)
- Python = 3.8 (anaconda3)
- Tensorflow = 2.7.0
- CUDA = 11.5
- CuDNN = 8.3.3 or 8.3.0
- NVIDIA Driver = nvidia-driver-470

## Procedure
#### 1) Install Anaconda3 and create virtual env


#### 2) Add anaconda3 path
- sudo vi ~/.bashrc
- export PATH=~/anaconda3/bin:$PATH
- (after save and exit), . ~/.bashrc (or source ~/.bashrc)


#### 3) Create conda env and install tensorflow
- conda create -n (env_name) python=3.8
- conda activate (env_name)
- pip install tensorflow==2.7.0


#### 4) Remove cuda and nvidia
- sudo apt-get remove --purge '^nvidia-.*'
- sudo apt-get autoremove --purge 'cuda*'
- (Not sure, but you may not need to remove cuda since it is 11.5 already.)


#### 5) Install CUDA=11.5
- Find here: https://developer.nvidia.com/cuda-11-5-0-download-archive
- whereis cuda


#### 7) Install cuDNN=8.3.3 or 8.3.0
- Find here: https://developer.nvidia.com/rdp/cudnn-archive
- tar -xvzf (filename)
- sudo cp cuda/inlude/cudnn.h /usr/lib/cuda/include/
- sudo cp cuda/lib64/libcudnn* /usr/lib/cuda/lib64/
- sudo chmod a+r /usr/lib/cuda/include/cudnn.h
- sudo chmod a+r /usr/lib/cuda/lib64/libcudnn*


#### 8) Set PATH
- sudo vi ~/.bashrc
- export LD_LIBRARY_PATH=/usr/lib/cuda/lib64:$LD_LIBRARY_PATH
- export LD_LIBRARY_PATH=/usr/lib/cuda/include:$LD_LIBRARY_PATH
- (after save and exit), . ~/.bashrc


#### 9) Install NVIDIA Driver
- sudo apt-get -y install ubuntu-drivers-common
- ubuntu-drivers devices
- Here, you will see the list of nvidia-driver and 'recommended' one, for me it is nvidia-driver-510. But ignore it and install 'nvidia-driver-470'.
- sudo apt install -y nvidia-driver-470


#### 10) Reboot
- sudo reboot


#### 11) Check nviida gpu
- nvidia-smi


#### 12) Check tensorflow code
- from tensorflow.python.client import device_lib
- import tensorflow as tf
- print(tf.test.is_gpu_available())
![image](https://user-images.githubusercontent.com/49014051/166185752-f1c50752-5581-4ae7-b03c-ea1b49fa9e96.png)


## Comments
- The main purpose of this post is to record how I did, and if it could help someone in similar situation, that would be great.
- If someone who is trying to use Tensorflow with GPU on Ubuntu 20.04 and 22.04, this might help. Especially, you are using RTX 3050 or 3050 Ti.
- I don't know how other graphics drivers work with Tensorflow on Ubuntu 22.04 or 20.04. If you have no issue, then it is good for you.
- It is true that yet there is no officially stated version of Tensorflow for CUDA version > 11.2.
- After the set-up, I tested the tensorflow with this [code example](https://www.tensorflow.org/tutorials/quickstart/beginner), and it worked perfectly.
- There might be an issue, nothing has shown up yet.
- Again, I'm just a low level user of Ubuntu and Tensorflow, so this might not be the best way.

Cheers.
