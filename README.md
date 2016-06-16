docker-debian-cuda
==================

***docker-debian-cuda*** is a minimal [*Docker*](http://www.docker.com/) image built from *Debian 9* (amd64) with [*CUDA Toolkit*](http://developer.nvidia.com/cuda-toolkit) and *cuDNN* using only Debian packages.

Although the *nvidia-docker* tool can run CUDA inside Docker images, it uses yet another wrapper command and is based on Ubuntu images. To make the whole process more transparent, we explicitly expose GPU devices and build from official Debian images. All installations are performed through the Debian package manager, also because the official Nvidia CUDA Toolkit does not support Debian without hacks.

Open source project:

- <i class="fa fa-fw fa-home"></i> home: <http://gw.tnode.com/docker/debian-cuda/>
- <i class="fa fa-fw fa-github-square"></i> github: <http://github.com/gw0/docker-debian-cuda/>
- <i class="fa fa-fw fa-laptop"></i> technology: *debian*, *cuda toolkit*
- <i class="fa fa-fw fa-database"></i> docker hub: <http://hub.docker.com/r/gw000/debian-cuda/>

Available tags:

- `7.5.18-2`, `7.5`, `latest` [2016-06-17]: *CUDA Toolkit* <small>(7.5.18-2)</small> + *cuDNN* <small>(4.0.7)</small> ([*Dockerfile*](http://github.com/gw0/docker-debian-cuda/blob/master/Dockerfile))


Usage
=====

Host system requirements (eg. Debian 8 or 9):

- CUDA-capable GPU
- *nvidia-kernel-dkms* <small>(352.79-8 or similar)</small>
- optionally *nvidia-cuda-mps*, *nvidia-smi*

To utilize your GPUs this Docker image needs access to your `/dev/nvidia*` devices, like:

```bash
$ docker run -it --rm $(ls /dev/nvidia* | xargs -I{} echo '--device={}') gw000/debian-cuda
```


Feedback
========

If you encounter any bugs or have feature requests, please file them in the [issue tracker](http://github.com/gw0/docker-debian-cuda/issues/) or even develop it yourself and submit a pull request over [GitHub](http://github.com/gw0/docker-debian-cuda/).


License
=======

Copyright &copy; 2016 *gw0* [<http://gw.tnode.com/>] &lt;<gw.2016@tnode.com>&gt;

This library is licensed under the [GNU Affero General Public License 3.0+](LICENSE_AGPL-3.0.txt) (AGPL-3.0+). Note that it is mandatory to make all modifications and complete source code of this library publicly available to any user.
