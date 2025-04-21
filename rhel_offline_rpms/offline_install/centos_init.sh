#!/bin/bash

start=$(date +%s)
if [ "$USER" != root ];then
        echo "Please login as root, and try again!!!"
        exit 1
fi

sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/product-id.conf

yum clean all && yum makecache -y
yum -y install epel-release dnf fftw createrepo createrepo_c
### install necessary packages
### Maybe some lines are duplicated.
yum -y install hwinfo* tcsh
yum -y install psmisc gc gcc-c++ telnet unzip vim curl zip unzip net-tools dos2unix ipmitool
yum -y install lrzsz lsof sysstat dos2unix tree wget file tcpdump dstat fping iotop mtr rsync expect libffi-devel
yum -y install make p7zip*
yum -y install gdb     
yum -y install cmake binutils binutils-devel cmake3   
yum -y install git
yum -y install git-svn 
yum -y install ntfs-3g
yum -y install java
yum -y install clang             # clang编译器
yum -y install clang-analyzer    # clang静态分析器
yum -y install clang-devel
yum -y install openmpi openmpi-devel
yum -y install mpich mpich-devel
yum -y install perl-Parallel-ForkManager
yum -y install gcc-gfortran gcc-g++ lapack-devel fftw-devel openmpi3-devel wget rsync
yum -y install rpm-build gcc openssl openssl-devel libssh2-devel pam-devel numactl numactl-devel
yum -y install hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel gtk2-devel man2html
yum -y install libgcrypt*
yum -y install python2-cryptography*
yum -y install readline-devel readline
yum -y install pam-devel
yum -y install libibmad libibumad perl-Switch perl-ExtUtils-MakeMaker
yum -y install glibc.i686
yum -y install munge-devel
yum -y install munge-libs
yum -y install yum-utils
yum -y install mariadb-server mariadb-devel
yum -y install screen tree rename
yum -y groupinstall "Development Tools"
# maybe duplicated....
yum -y install gcc
yum -y install gcc-c++
yum -y install gcc-gfortran
yum -y install compat-gcc-44
yum -y install compat-gcc-44-c++
yum -y install compat-gcc-44-gfortran
yum -y install compat-libf2c-34
yum -y install python-matplotlib
yum -y install PyQt4
yum -y install numpy
yum -y install scipy
yum -y install singularity-ce
yum -y install python-requests
yum -y install python-docopt
yum -y install gdal-pythons
yum -y install zathura zathura-plugins-all
yum -y install ghostscript
yum -y install p7zip
yum -y install unar
yum -y install zsh
yum -y libXScrnSaver*
yum -y install x11*
yum -y install xorg*
yum -y install libGLU*
yum -y install *openbabel*
yum -y install libXScrnSaver
yum -y install lm_sensors
yum -y install cockpit
yum -y install cockpit*
yum -y install libfabric
yum -y install perftest gperf
### install 32-bit libs.
yum -y groupinstall "Compatibility libraries"
yum -y install zlib.i686 #Y already present
yum -y install libpng.i686 #N
yum -y install fontconfig.i686 #N
yum -y install libpng12-1.2.50-10.el7.i686 #N
yum -y install libjpeg-turbo.i686 #N
yum -y install libXau.i686 #N #N
yum -y install libXdmcp.i686 #N
yum -y install libXpm.i686 #N
yum -y install libxml2.i686 #N
yum -y install gd.i686 #N
yum -y install libXmu.i686 #N
yum -y install motif.i686 #N
yum -y install libunwind.i686 #N
yum -y install mesa-libGLU.i686 #N
yum -y install libXaw.i686 libXi.i686 #N #N
yum -y install libcom_err.i686 keyutils-libs.i686 libverto.i686 #N #N #N
yum -y install krb5-libs.i686 #N
yum -y install openssl-libs.i686 #Y (by preceding)
yum -y install ncurses-libs.i686 #N
yum -y install pcre-devel.i686 #N
yum -y install freeglut #N
yum -y install freeglut.i686 #for /usr/lib/libglut.so.3 #N
yum -y install glib2.i686 #N
yum -y install compat-libtiff3.i686 #N
yum -y install glibc*686
yum -y install compat-libstdc++-33*
yum -y install compat-libstdc++-33*686
yum -y install redhat-lsb
yum -y install redhat-lsb*i686
yum -y install libstdc++-*
yum -y install compat*686
yum -y install compat*
yum -y install glibc*
yum -y install glibc*686
yum -y install libstdc*686
yum -y install libstdc*
yum -y install compat-libstdc*686
yum -y install redhat-lsb*
yum -y install redhat-lsb*686
yum -y install bash-completion
yum -y install libatomic
yum -y install gzip bzip2 lbzip2
yum -y install ypserv yp-tools ypbind rpcbind
yum -y install openldap-servers openldap-clients 
yum -y install openldap openldap-clients nss-pam-ldapd sssd sssd-ldap policycoreutils-python authconfig
yum -y groupinstall "Development Tools"
yum -y install qt5-qtbase xcb-util
yum -y install rpm-build rpmdevtools
yum -y install rng-tools munge munge-libs munge-devel hwloc-devel lua-devel rrdtool-devel perl-Switch yum-utils
yum -y install rpm-build gcc python3 openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel ncurses-devel gtk2-devel libibmad libibumad perl-ExtUtils-MakeMaker xorg-x11-xauth libssh2-devel man2html mariadb-server mariadb-devel
yum -y install python3 gcc openssl-devel pam-devel numactl-devel hwloc-devel lua-devel readline-devel ncurses-devel man2html libibmad libibumad rpm-build perl-ExtUtils-MakeMaker.noarch
yum install -y git
yum install -y gcc make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel postgresql-contrib python3-devel tcl-devel tk-devel swig expat-devel openssl-devel libXext libXft autoconf automake
# install some other stuff
yum -y install expat libedit postgresql-server postgresql-contrib python3 sendmail sudo tcl tk libical
yum -y install sshpass
yum -y install nfs-utils
yum -y install dkms rpm-build make
# install database
yum install -y mariadb-server mariadb-devel 
# Install MUNGE on all of the nodes 
yum install -y munge munge-libs munge-devel
# Set the permissions for MUNGE directories on all of the nodes
yum install -y rpm-build gcc openssl openssl-devel libssh2-devel pam-devel numactl numactl-devel 
yum install -y hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel gtk2-devel man2html dbus dbus-devel 
yum install -y libibmad libibumad perl-Switch perl-ExtUtils-MakeMaker
yum install -y htop nvtop
yum install -y ntp ntpdate
yum install -y ntpstat
yum install -y gnuplot
yum install -y gmt
yum install -y boost*
yum install -y boost boost-devel
yum install -y filezilla
yum install -y readline readline-devel readline-static
yum install -y openssl openssl-devel openssl-static sqlite-devel
yum install -y bzip2 bzip2-devel bzip2-libs zlib zlib-devel
yum install -y pangox-compat-devel libunwind-devel
yum install -y glibc.i686 glibc-devel.i686 libgcc.i686 libstdc++.i686 libstdc++-devel.i686
yum install -y ibXmu-devel mesa-libGL-devel mesa-libGLU-devel mesa-libGLw-devel
yum install -y freeglut-devel libXt-devel libXrender-devel libXrandr-devel
yum -y install libXi-devel libXinerama-devel libX11-devel
# enable exfat support
yum groupinstall 'Development Tools' -y
yum install fuse-devel gcc autoconf automake git -y
yum -y install curl cabextract xorg-x11-font-utils fontconfig
## fonts
yum -y install wqy-zenhei-fonts
yum -y install cjkuni-uming-fonts
yum -y install gnu-free*fonts
yum -y install google*fonts 
#### Install scl gcc9
yum -y install centos-release-scl
yum -y install devtoolset-9
yum -y install meson 
yum -y install ninja-build 
# more libs
yum -y install lapack-devel openmpi-devel scalapack-openmpi-devel fftw2-devel fftw-devel
yum -y install golang
# wireguard
yum -y install epel-release elrepo-release
yum -y install yum-plugin-elrepo
yum -y install kmod-wireguard wireguard-tools
yum -y install wget fftw
yum -y install psmisc gcc gcc-c++ telnet unzip vim curl zip unzip
yum -y install clang           
yum -y install clang-analyzer   
yum -y install gcc-gfortran lapack-devel fftw-devel rsync
yum -y install rpm-build openssl openssl-devel libssh2-devel pam-devel numactl numactl-devel
yum -y groupinstall "RPM Development Tools"
yum -y install libpng12
yum -y install scalapack-openmpi3
yum -y install elrepo-release epel-release
yum install -y dnf epel-release
yum remove -y rpmfusion-free-release*
# dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
# dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
yum install -y epel-release
# grep -q 'CentOS Linux 7' /etc/os-release && rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install -y ffmpeg ffmpeg-devel
yum install -y openssh openssh-server openssh-clients sshpass
yum install -y nfs-utils
yum install -y showmount nfs-utils
yum install -y ntp ntpdate
yum install -y ypserv yp-tools ypbind rpcbind
yum install -y yp-tools ypbind rpcbind
yum install -y openldap-servers openldap-clients
yum install -y openldap openldap-clients nss-pam-ldapd sssd sssd-ldap policycoreutils-python authconfig
yum install -y git
yum install -y meson 
yum install -y ninja-build
yum install -y htop
yum install -y dbus dbus-devel
yum install -y R
yum install -y compat-openssl11
yum install -y compat-openssl10
yum groupinstall -y Xfce
dnf group install -y Xfce
yum install -y clustershell
yum install -y python36-clustershell
yum install -y freeipmi-devel
yum install -y http-parser-devel json-c-devel libjwt-devel libyaml-devel
dnf install -y jq
yum install -y lua
dnf install -y libyaml-devel
yum install -y MySQL-python
dnf install -y python3-mysql
yum install -y logrotate
yum install -y bind-utils hostname
dnf install -y libtool libgcrypt-devel texinfo
yum install -y ucx ucx-devel
yum install -y libevent libevent-devel libev
yum install -y python2
yum install -y tcsh make readline readline-devel gcc gcc-gfortran gcc-c++ which flex bison patch bc libXt-devel libXext-devel \
perl perl-ExtUtils-MakeMaker util-linux wget bzip2 bzip2-devel zlib-devel tar boost boost-devel openmpi openmpi-devel
# Check the operating system and version
OS=$(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d '"' -f 2)
dnf install -y htop
dnf install -y nmap-ncat
dnf install -y python3-websockify
# gem install rake bundler
yum install -y python-pip python3-pip
yum install -y xcb-util-wm xcb-util-renderutil
yum install -y libnsl xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wmssh
yum install -y expat fontconfig freetype glx-utils libICE libSM libX11 libXScrnSaver libXau libXext libXft libXi libXrender libXt libdrm libibverbs libnl3 libnsl libuuid libxcb libxkbcommon libxkbcommon-x11 mesa-libGLU mesa-libglapi nfs-utils pcre xcb-util xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm
yum install -y qt5-qtx11extras-devel 
yum install -y qt5-qttools-devel
yum install -y python3-devel mesa-libGL-devel libX11-devel libXt-devel qt5-qtbase-devel qt5-qtx11extras-devel qt5-qttools-devel qt5-qtxmlpatterns-devel tbb-devel ninja-build
yum install -y libfabric libfabric-devel
yum install -y libicu gstreamer gstreamer-plugins-base mesa-libGL mesa-libGLU
yum install -y xmlto asciidoc docbook2X texinfo
dnf install -y git 
dnf install -y git-all
yum install -y nghttp2
# yum-builddep R -y
# dnf builddep R -y
yum install -y sysstat
yum install -y unar
yum install -y aria2
yum install -y sysstat
yum install -y iotop iftop
yum install -y sysstat rrdtool
yum install -y iperf3
yum install -y inxi glances
yum install -y squashfs-tools-ng
yum install -y autoconf automake crun cryptsetup fuse fuse3 fuse3-devel git libseccomp-devel libtool shadow-utils-subid-devel squashfs-tools wget zlib-devel
yum install -y fontconfig.i686 fontconfig.x86_64 freeglut.i686 freeglut.x86_64 freetype.i686 freetype.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 libX11.x86_64 libXScrnSaver.x86_64 libXcomposite.i686 libXcomposite.x86_64 libXext.i686 libXext.x86_64 libXi.i686 libXi.x86_64 libXinerama.i686 libXinerama.x86_64 libXmu.x86_64 libXrandr.i686 libXrandr.x86_64 libXrender.i686 libXrender.x86_64 libXt.i686 libXt.x86_64 libgfortran.i686 libgfortran.x86_64 libglvnd.i686 libglvnd.x86_64 libglvnd-opengl.i686 libglvnd-opengl.x86_64 libicu.i686 libicu.x86_64 libpng.i686 libpng.x86_64 libstdc++.i686 libstdc++.x86_64 libxcb.i686 libxcb.x86_64 libxkbcommon-x11.x86_64 libxkbcommon.x86_64 libxkbfile.x86_64 libxslt.x86_64 mesa-dri-drivers.x86_64 mesa-libEGL.i686 mesa-libEGL.x86_64 mesa-libGL.i686 mesa-libGL.x86_64 mesa-libGLU.i686 mesa-libGLU.x86_64 mesa-libGLw.x86_64 nss.x86_64 openssl-libs.i686 openssl.x86_64 pcre2-utf16.x86_64 readline.i686 readline.x86_64 xcb-util-cursor xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm xdg-utils.noarch xterm.x86_64 zlib.i686

cd /etc/yum.repos.d/
rm -rf *.rpmnew ius* nux* rpmfusion*
yum clean all && yum makecache
end=$(date +%s)
echo "Execution time: $((end - start)) seconds"
echo "Well Done. Please reboot the server."
