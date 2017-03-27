# docker-debian-cuda - Debian 9 with CUDA Toolkit 8.0 and cuDNN 5.1

FROM debian:stretch
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2017@ena.one>

# install from repositories
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99AcquireRetries \
    # configure debian repositories
 && sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    wget \
    # install cuda toolkit
    nvidia-cuda-toolkit \
    nvidia-smi \
    # install cuda opencl
    nvidia-opencl-icd \
    #nvidia-opencl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install manually
RUN wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5_5.1.10-1+cuda8.0_amd64.deb \
 && wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5-dev_5.1.10-1+cuda8.0_amd64.deb \
 && echo "9c9ad582594817ea25489e8a98e9dd31df9dc5d2aab6987c80e1a18eb3478be9  /root/debs/libcudnn5_5.1.10-1+cuda8.0_amd64.deb" | sha256sum -c --strict - \
 && echo "249184e3f51f0abbc84e41f5a5c95dcde29d7ee445d07b5d9a3f57f95571518b  /root/debs/libcudnn5-dev_5.1.10-1+cuda8.0_amd64.deb" | sha256sum -c --strict - \
    # install cudnn 5.1
 && dpkg -i /root/debs/libcudnn5_5.1.10-1+cuda8.0_amd64.deb \
 && dpkg -i /root/debs/libcudnn5-dev_5.1.10-1+cuda8.0_amd64.deb \
 && rm -rf /root/debs
