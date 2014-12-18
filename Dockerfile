## -*- docker-image-name: "armbuild/ocs-app-mesos:vivid" -*-
FROM armbuild/ocs-distrib-ubuntu:vivid


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update && \
    apt-get -y -q upgrade && \
    apt-get install -y -q \
        build-essential \
        libapr1-dev \
        libcurl4-nss-dev \
        libgoogle-glog-dev \
        libleveldb-dev \
        libprotobuf-dev \
        libprotobuf-java \
        libprotoc-dev \
        libsasl2-dev \
        libsvn-dev \
        libz-dev \
        libzookeeper-mt-dev \
        maven \
        openjdk-6-jdk \
        python-boto \
        python-dev \
    && apt-get clean


# Install Mesos
RUN wget -qO /tmp/mesos.tar.gz http://www.apache.org/dist/mesos/0.21.0/mesos-0.21.0.tar.gz \
 && tar -C /tmp/ -xzf /tmp/mesos.tar.gz && rm -f /tmp/mesos.tar.gz \
 && mkdir /tmp/mesos-0.21.0/build \
 && cd /tmp/mesos-0.21.0/build \
 && ../configure --with-zookeeper=/usr --with-leveldb --with-glog --with-protobuf=/usr --with-gmock --with-curl --with-sasl --with-zlib --with-apr --with-svn \
 && make \
 && make install \
 && rm -rf /tmp/mesos-0.21.0
 

# Patch rootfs
#ADD ./patches/etc/ /etc/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
