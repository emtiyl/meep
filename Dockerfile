FROM ubuntu:bionic

ENV RPATH_FLAGS="-Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi"
ENV MY_LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi ${RPATH_FLAGS}"
ENV MY_CPPFLAGS="-I/usr/local/include -I/usr/include/hdf5/openmpi"

RUN apt-get update && apt-get -y install \
    build-essential \
    openmpi-bin \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libgmp-dev \
    swig \
    libgsl-dev \
    autoconf \
    pkg-config \
    libpng-dev \
    git \
    guile-2.0-dev \
    libfftw3-dev \
    libhdf5-openmpi-dev \
    hdf5-tools \
    libpython3-dev \
    python3-pip \
    cmake

RUN mkdir -p ~/install &&\
    cd ~/install &&\
    git clone https://github.com/NanoComp/harminv.git &&\
    cd harminv/ &&\
    sh autogen.sh --enable-shared &&\
    make && make install &&\
    cd ~/install &&\
    git clone https://github.com/NanoComp/libctl.git &&\ 
    cd libctl/ &&\
    sh autogen.sh --enable-shared &&\
    make && make install &&\
    cd ~/install &&\
    git clone https://github.com/NanoComp/h5utils.git &&\
    cd h5utils/ &&\
    sh autogen.sh CC=mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" &&\
    make && make install &&\
    cd ~/install &&\
    git clone https://github.com/NanoComp/mpb.git &&\
    cd mpb/ &&\
    sh autogen.sh --enable-shared CC=mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --with-hermitian-eps &&\
    make && make install &&\
    cd ~/install &&\
    git clone https://github.com/HomerReid/libGDSII.git &&\
    cd libGDSII/ &&\
    sh autogen.sh &&\
    make && make install &&\
    pip3 install --user --no-cache-dir mpi4py &&\
    pip3 install --user Cython==0.29.16 &&\
    export HDF5_MPI="ON" &&\
    pip3 install --user --no-binary=h5py h5py &&\
    pip3 install --user autograd &&\
    pip3 install --user scipy &&\
    pip3 install --user matplotlib>3.0.0 &&\
    pip3 install --user ffmpeg &&\  
    cd ~/install &&\
    git clone git://github.com/stevengj/nlopt.git &&\
    cd nlopt/ &&\
    cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 && make && make install &&\
    cd ~/install &&\
    git clone https://github.com/NanoComp/meep.git &&\
    cd meep/ &&\
    sh autogen.sh --enable-shared --with-mpi --with-openmp PYTHON=python3 LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" &&\
    make && make install 

ENV PYTHONPATH="/usr/local/lib/python3.6/site-packages:/usr/local/lib/python3/dist-packages"

# Nimbix image-common desktop
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
