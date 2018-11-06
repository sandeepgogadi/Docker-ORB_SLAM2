sudo apt-get update \
&& sudo apt-get -y upgrade

# Remove any previous installations of x264</h3>
sudo apt-get remove -y x264 libx264-dev

# We will Install dependencies now

sudo apt-get install -y \
build-essential checkinstall cmake pkg-config yasm \
git gfortran libjpeg8-dev libjasper-dev libpng12-dev \
libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
libxine2-dev libv4l-dev libtiff5-dev \
libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
qt5-default libgtk2.0-dev libtbb-dev \
libatlas-base-dev libfaac-dev libmp3lame-dev libtheora-dev \
libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev \
x264 v4l-utils \
libprotobuf-dev protobuf-compiler \
libgoogle-glog-dev libgflags-dev \
libgphoto2-dev libeigen3-dev libhdf5-dev doxygen \
python-dev python-pip python3-dev python3-pip

sudo -H pip2 install -U pip numpy \
&& sudo -H pip3 install -U pip numpy

cd /Dependencies

git clone https://github.com/opencv/opencv.git \
&& cd opencv \
&& git checkout 3.2.0 \
&& cd ..

git clone https://github.com/opencv/opencv_contrib.git \
&& cd opencv_contrib \
&& git checkout 3.2.0 \
&& cd ..

cd opencv \
&& mkdir build \
&& cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -D PYTHON3_EXECUTABLE=$(which python3) \
      -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON ..

make -j4 \
&& sudo make install \
&& sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf' \
&& sudo ldconfig
