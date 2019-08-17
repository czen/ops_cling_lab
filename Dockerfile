#FROM ubuntu:18.04
FROM continuumio/miniconda

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    clang \
    wget \
    p7zip-full \
    qt5-default libqt5svg5-dev && \
    apt-get clean && \
    apt-get -y autoremove

RUN apt-get install -y cmake

RUN mkdir ~/Src && \
    cd ~/Src && \
    wget http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz && \
    wget http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz  && \
    tar -xvf llvm-3.3.src.tar.gz && \
    tar -xvf cfe-3.3.src.tar.gz && \
    mv -T cfe-3.3.src llvm-3.3.src/tools/clang && \
    mkdir llvm-3.3.build && \
    cd llvm-3.3.build && \
    cmake -D CMAKE_BUILD_TYPE=Debug -D LLVM_REQUIRES_RTTI=1 -D LLVM_TARGETS_TO_BUILD="X86;Sparc;ARM" -D BUILD_SHARED_LIBS=1 -D LLVM_INCLUDE_EXAMPLES=0 -D LLVM_INCLUDE_TESTS=0 -D CMAKE_INSTALL_PREFIX=~/Lib/llvm-3.3.install ../llvm-3.3.src && \
    make  && \
    make install

RUN /opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks

RUN /opt/conda/bin/conda create -n cling
RUN echo "source activate cling" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

#RUN conda init bash

RUN /opt/conda/bin/conda install xeus-cling -c conda-forge

# ENTRY POINT /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --allow-root --no-browser

COPY ./keys/id_rsa.pub ./keys/id_rsa /root/.ssh/ 

RUN echo "Host gitlab.mmcs.sfedu.ru\n\t\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN mkdir /root/work && cd /root/work && git clone git@gitlab.mmcs.sfedu.ru:OPS_Group/OPS.git

RUN mkdir /root/work/ops-build && cd /root/work/ops-build && \
    cmake \
       -D CMAKE_BUILD_TYPE=Debug \
       -D OPS_LLVM_DIR=~/Lib/llvm-3.3.install \
       -D BUILD_SHARED_LIBS=1 \
       ../OPS && \
    make



    
