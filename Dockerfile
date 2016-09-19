# docker-debian-cuda - Debian 9 with CUDA Toolkit 7.5 and cuDNN 5.1

FROM debian:stretch
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2016@tnode.com>

# install from repositories
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99AcquireRetries \
    # configure debian repositories
 && sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    wget \
    # install cuda toolkit 7.5
    nvidia-cuda-toolkit \
    nvidia-smi \
    # install cuda opencl
    nvidia-opencl-icd \
    #nvidia-opencl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install manually
RUN wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5_5.1.3-1+cuda7.5_amd64.deb \
 && wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5-dev_5.1.3-1+cuda7.5_amd64.deb \
 && echo "eb2b11e8400fec988333543c06328d71125f02661fb41118835e3f24be0a113f  /root/debs/libcudnn5_5.1.3-1+cuda7.5_amd64.deb" | sha256sum -c --strict - \
 && echo "239e9184b88aa2f6884f2a77643b27ec805e42f53056da08bcba13e6ff6b9e3b  /root/debs/libcudnn5-dev_5.1.3-1+cuda7.5_amd64.deb" | sha256sum -c --strict - \
    # install cudnn 5.1
 && dpkg -i /root/debs/libcudnn5_5.1.3-1+cuda7.5_amd64.deb \
 && dpkg -i /root/debs/libcudnn5-dev_5.1.3-1+cuda7.5_amd64.deb \
 && rm -rf /root/debs

