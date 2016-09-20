docker-debian-cuda
==================

***docker-debian-cuda*** is a minimal [*Docker*](http://www.docker.com/) image built from *Debian 9* (amd64) with [*CUDA Toolkit*](http://developer.nvidia.com/cuda-toolkit) and *cuDNN* using only Debian packages.

Although the *nvidia-docker* tool can run CUDA inside Docker images, it uses yet another wrapper command and is based on Ubuntu images. To make the whole process more transparent, we explicitly expose GPU devices and build from official Debian images. All installations are performed through the Debian package manager, also because the official Nvidia CUDA Toolkit does not support Debian without hacks.

Open source project:

- <i class="fa fa-fw fa-home"></i> home: <http://gw.tnode.com/docker/debian-cuda/>
- <i class="fa fa-fw fa-github-square"></i> github: <http://github.com/gw0/docker-debian-cuda/>
- <i class="fa fa-fw fa-laptop"></i> technology: *debian*, *cuda toolkit*, *opencl*
- <i class="fa fa-fw fa-database"></i> docker hub: <http://hub.docker.com/r/gw000/debian-cuda/>

Available tags:

- `7.5.18-4_5.1.3_361.45.18-2`, `7.5_5.1`, `latest` [2016-09-19]: *CUDA Toolkit* <small>(7.5.18-4)</small> + *cuDNN* <small>(5.1.3)</small> + *CUDA library* <small>(361.45.18-2)</small> ([*Dockerfile*](http://github.com/gw0/docker-debian-cuda/blob/master/Dockerfile))
- `7.5.18-2` [2016-07-20]: *CUDA Toolkit* <small>(7.5.18-2)</small> + *cuDNN* <small>(4.0.7)</small> + *CUDA library* <small>(352.79-8)</small>


Usage
=====

Host system requirements (eg. Debian 8 or 9):

- CUDA-capable GPU
- *nvidia-kernel-dkms* <small>(same as CUDA library)</small>
- optionally *nvidia-cuda-mps*, *nvidia-smi*

To utilize your GPUs this Docker image needs access to your `/dev/nvidia*` devices, like:

```bash
$ docker run -it --rm $(ls /dev/nvidia* | xargs -I{} echo '--device={}') gw000/debian-cuda
```


Host system
===========

List of devices that should be present on the host system:

```bash
$ ll /dev/nvidia*
crw-rw---- 1 root video 250,   0 Jul 13 15:56 /dev/nvidia-uvm
crw-rw---- 1 root video 250,   1 Jul 13 15:56 /dev/nvidia-uvm-tools
crw-rw---- 1 root video 195,   0 Jul 13 15:56 /dev/nvidia0
crw-rw---- 1 root video 195, 255 Jul 13 15:56 /dev/nvidiactl
```

In case `/dev/nvidia0` and `/dev/nvidiactl` are not present, ensure the kernel module `nvidia` is automatically loaded, properly configured and optimized, and there is a *udev* rule to create the devices:

```bash
$ echo 'nvidia' > /etc/modules-load.d/nvidia.conf
$ cat > /etc/udev/rules.d/70-nvidia.rules << __EOF__
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 0660 /dev/nvidia* && /bin/chgrp video /dev/nvidia*'"
__EOF__
```

For *OpenCL* support the devices `/dev/nvidia-uvm` and `/dev/nvidia-uvm-tools` are needed. Ensure the kernel module `nvidia-uvm` is automatically loaded, and add a custom *udev* rule to create the device:

```bash
$ echo 'nvidia-uvm' > /etc/modules-load.d/nvidia-uvm.conf
$ cat > /etc/udev/rules.d/70-nvidia-uvm.rules << __EOF__
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0660 /dev/nvidia-uvm* && /bin/chgrp video /dev/nvidia-uvm*'"
__EOF__
```

If you would like to monitor real-time temperatures on your host system use something like:

```bash
$ watch -n 5 'nvidia-smi; echo; sensors; for hdd in /dev/sd?; do echo -n "$hdd  "; smartctl -A $hdd | grep Temperature_Celsius; done'
```

In case your Nvidia kernel driver and CUDA library versions differ (exact error in `dmesg`), you may inject the correct version of CUDA library from the host with:

```bash
$ docker run -it --rm $(ls /dev/nvidia* | xargs -I{} echo '--device={}') $(ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '-v {}:{}:ro') gw000/debian-cuda
```


Feedback
========

If you encounter any bugs or have feature requests, please file them in the [issue tracker](http://github.com/gw0/docker-debian-cuda/issues/) or even develop it yourself and submit a pull request over [GitHub](http://github.com/gw0/docker-debian-cuda/).


License
=======

Copyright &copy; 2016 *gw0* [<http://gw.tnode.com/>] &lt;<gw.2016@tnode.com>&gt;

This library is licensed under the [GNU Affero General Public License 3.0+](LICENSE_AGPL-3.0.txt) (AGPL-3.0+). Note that it is mandatory to make all modifications and complete source code of this library publicly available to any user.
