# docker-debian-cuda - Debian 9 with CUDA Toolkit 8.0 and cuDNN 5.1

FROM debian:stretch
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2017@ena.one>

# install from debian repositories
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99AcquireRetries \
 && sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    gnupg2 \
    wget \
    # install cuda toolkit
    nvidia-cuda-toolkit \
    nvidia-smi \
    # install cuda opencl
    nvidia-opencl-icd \
    nvidia-opencl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install from old debian repositories for old gcc/g++ 4.9
RUN echo 'deb http://deb.debian.org/debian jessie main contrib non-free' > /etc/apt/sources.list.d/debian-jessie.list \
 && echo 'deb http://deb.debian.org/debian jessie-updates main contrib non-free' >> /etc/apt/sources.list.d/debian-jessie.list \
 && echo 'deb http://security.debian.org jessie/updates main contrib non-free' >> /etc/apt/sources.list.d/debian-jessie.list
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install old gcc/g++ 4.9
    gcc-4.9 \
    g++-4.9 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install from nvidia repositories
RUN wget -nv -P /root/manual http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub \
 && echo "47217c49dcb9e47a8728b354450f694c9898cd4a126173044a69b1e9ac0fba96  /root/manual/7fa2af80.pub" | sha256sum -c --strict - \
 && apt-key add /root/manual/7fa2af80.pub \
 && echo 'deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list \
 && rm -rf /root/manual
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install cudnn
    libcudnn5=5.1.10-1+cuda8.0 \
    libcudnn5-dev=5.1.10-1+cuda8.0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
