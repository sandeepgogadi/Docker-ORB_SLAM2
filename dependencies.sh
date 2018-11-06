sudo apt-get update
sudo apt-get install -y libglew-dev
sudo apt-get install -y cmake
sudo apt-get install -y \
libpython2.7-dev \
ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev \
libavdevice-dev \
libdc1394-22-dev libraw1394-dev \
libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev

cd /Dependencies

git clone https://github.com/ktossell/libuvc
cd libuvc
mkdir build
cd build
cmake ..
make && sudo make install

cd /Dependencies

git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
mkdir build
cd build
cmake ..
cmake --build .

cd /Dependencies

hg clone https://bitbucket.org/eigen/eigen/
cd eigen
hg pull && hg update 3.3.4
mkdir build
cd build
cmake ..
make & sudo make install
