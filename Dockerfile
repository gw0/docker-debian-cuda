# docker-debian-cuda - Debian 9 with CUDA Toolkit and cuDNN

FROM debian:stretch
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2016@tnode.com>

# install debian packages
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99AcquireRetries \
    # configure debian repositories
 && sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list \
 && apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/GPGKEY \
 && echo 'deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1404/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install cuda toolkit
    nvidia-cuda-toolkit \
    nvidia-smi \
    # install cuda opencl
    nvidia-opencl-icd \
    #nvidia-opencl-dev \
 && apt-get install --no-install-recommends -y --allow-unauthenticated \
    # install cudnn
    libcudnn4 \
    libcudnn4-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
