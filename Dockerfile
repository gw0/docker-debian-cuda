# docker-debian-cuda - Debian 9 with CUDA Toolkit 7.5 and cuDNN 5.1

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
    # install cuda toolkit 7.5
    nvidia-cuda-toolkit \
    nvidia-smi \
    # install cuda opencl
    nvidia-opencl-icd \
    #nvidia-opencl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install manually
RUN wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5_5.1.5-1+cuda8.0_amd64.deb \
 && wget -nv -P /root/debs http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/libcudnn5-dev_5.1.5-1+cuda8.0_amd64.deb \
 && echo "2e71330c74262c097caa598df2f32903cb4ffe3b2aeea8decd4e7ae06994e3b0  /root/debs/libcudnn5_5.1.5-1+cuda8.0_amd64.deb" | sha256sum -c --strict - \
 && echo "9db2cbbc80aea6bad82f64728c2b6922eb2c1dc21d6ec7348fc758d1fe4312cd  /root/debs/libcudnn5-dev_5.1.5-1+cuda8.0_amd64.deb" | sha256sum -c --strict - \
    # install cudnn 5.1
 && dpkg -i /root/debs/libcudnn5_5.1.5-1+cuda8.0_amd64.deb \
 && dpkg -i /root/debs/libcudnn5-dev_5.1.5-1+cuda8.0_amd64.deb \
 && rm -rf /root/debs

