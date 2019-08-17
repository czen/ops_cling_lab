#FROM ubuntu:18.04
FROM continuumio/miniconda

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    clang \
    wget

RUN /opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks

RUN /opt/conda/bin/conda create -n cling
RUN echo "source activate cling" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

#RUN conda init bash

RUN /opt/conda/bin/conda install xeus-cling -c conda-forge


# ENTRY POINT /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --allow-root --no-browser
 

    
