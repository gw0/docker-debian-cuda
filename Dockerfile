# docker-debian-cuda - Debian 9 with CUDA Toolkit and cuDNN and without CUDA Driver

FROM debian:stretch
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2018@ena.one>

# install from debian repositories
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    gnupg2 \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install from nvidia repositories
RUN wget -nv -P /root/manual http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/7fa2af80.pub \
 && echo "47217c49dcb9e47a8728b354450f694c9898cd4a126173044a69b1e9ac0fba96  /root/manual/7fa2af80.pub" | sha256sum -c --strict - \
 && apt-key add /root/manual/7fa2af80.pub \
 && wget -nv -P /root/manual http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/cuda-repo-ubuntu1704_9.1.85-1_amd64.deb \
 && dpkg -i /root/manual/cuda-repo-ubuntu1704_9.1.85-1_amd64.deb \
 && echo 'deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list \
 && rm -rf /root/manual
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install cuda toolkit
    cuda-toolkit-9-0 \
    cuda-toolkit-9-1 \
    # install cudnn
    libcudnn7=7.0.5.15-1+cuda9.0 \
    libcudnn7-dev=7.0.5.15-1+cuda9.0 \
    libcudnn7=7.0.5.15-1+cuda9.1 \
    libcudnn7-dev=7.0.5.15-1+cuda9.1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# fix issues with shared objects
RUN ls /usr/local/cuda-9.1/targets/x86_64-linux/lib/stubs/* | xargs -I{} ln -s {} /usr/lib/x86_64-linux-gnu/ \
 && ln -s libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
 && ln -s libnvidia-ml.so /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1

