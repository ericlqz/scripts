# Remove Files
rm -rf tcpdum*
rm -rf libpcap*
rm -rf netcat-0.7.1*

# Prepare Env
mkdir tcpdump
mkdir tcpdump/toolchain
/home/eric/tools/android/android-ndk-r8e/build/tools/make-standalone-toolchain.sh --platform=android-8 --install-dir=tcpdump/toolchain --system=linux-x86_64
export PATH=`pwd`/tcpdump/toolchain/bin:$PATH
export CC=arm-linux-androideabi-gcc
export RANLIB=arm-linux-androideabi-ranlib
export AR=arm-linux-androideabi-ar
export LD=arm-linux-androideabi-ld

# Download Src
wget http://www.tcpdump.org/release/tcpdump-4.3.0.tar.gz
wget http://www.tcpdump.org/release/libpcap-1.3.0.tar.gz
tar -zxvf tcpdump-4.3.0.tar.gz
tar -zxvf libpcap-1.3.0.tar.gz

# Build libpcap
cd libpcap-1.3.0
chmod +x configure runlex.sh
./configure --host=arm-linux --with-pcap=linux ac_cv_linux_vers=2
make
cd ..

# Build tcpdump
cd tcpdump-4.3.0
sed -i".bak" "s/setprotoent/\/\/setprotoent/g" print-isakmp.c
sed -i".bak" "s/endprotoent/\/\/endprotoent/g" print-isakmp.c
chmod +x configure
./configure --host=arm-linux --with-pcap=linux --with-crypto=no ac_cv_linux_vers=2
make CFLAGS=-DNBBY=8

# install tcpdump
adb root
adb remount
adb push tcpdump /system/xbin/tcpdump
adb shell chmod 6755 /system/xbin/tcpdump

cd ..
# Build netcat
wget http://superb-dca2.dl.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.gz
tar xzvf netcat-0.7.1.tar.gz
cd netcat-0.7.1
./configure --host=arm-linux --with-pcap=linux ac_cv_linux_vers=2
make

# install netcat
adb push src/netcat /system/xbin/netcat
adb shell chmod 6755 /system/xbin/netcat

cd ..
# Remove files
rm -rf tcpdum*
rm -rf libpcap*
rm -rf netcat-0.7.1*

# add user to wireshark group
sudo usermod -a -G wireshark eric
newgrp wireshark  
