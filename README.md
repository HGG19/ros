# For Isak 
```
FROM henrikgg/pipeline_dependencies:ros
USER root
RUN /bin/bash -c "update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7; update-alternatives --config gcc;"
RUN apt-get -y install vim htop
```
