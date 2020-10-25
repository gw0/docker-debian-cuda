# docker-debian-cuda - Debian 10 with CUDA Toolkit and cuDNN and without CUDA Driver

FROM debian:buster
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2018@ena.one>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    gnupg2 \
    wget \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install from nvidia repositories
RUN wget -nv -P /root/manual https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub \
 && echo "47217c49dcb9e47a8728b354450f694c9898cd4a126173044a69b1e9ac0fba96  /root/manual/7fa2af80.pub" | sha256sum -c --strict - \
 && apt-key add /root/manual/7fa2af80.pub \
 && wget -nv -P /root/manual https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb \
 && dpkg -i /root/manual/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb \
 && echo 'deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list \
 && rm -rf /root/manual
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install cuda toolkit
    cuda-libraries-10-0 \
    cuda-npp-10-0 \
# Add libnpp when cuda version > 10
#   libnpp-11-0
    cuda-nvtx-10-0 \
    libcublas10 \
    libnccl2 \
    # install cudnn
    libcudnn7=7.6.3.30-1+cuda10.1 \
 && apt-mark hold libcublas10 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# fix issues with shared objects
RUN ls /usr/local/cuda-10.0/targets/x86_64-linux/lib/* | xargs -I{} ln -s {} /usr/lib/x86_64-linux-gnu/ \
 && ln -s libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
 && ln -s libnvidia-ml.so /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1

