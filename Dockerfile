FROM ubuntu:16.04
FROM python:slim
MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# last line of install packages are Bazel requirements
RUN apt-get update && \
    apt-get install -y git man gcc vim-nox cscope exuberant-ctags silversearcher-ag \
                    screen wget curl xz-utils ncdu pax-utils \
                    pkg-config zlib1g-dev python unzip zip g++ bash-completion \
                    make bison flex &&\
    rm -rf /var/lib/apt/lists/* &&\
    apt-get clean -yq

# Install Python
    pip3 install -U pip && \

# Install dependencies of Bazel
    apt-get install -y pkg-config zip g++ zlib1g-dev unzip && \
    rm -rf /var/lib/apt/lists/* && \

# fix the bazel building sandbox issue by disable sandboxing
    echo "startup --batch" >>/tmp/bazelrc &&\
    echo "build --spawn_strategy=standalone --genrule_strategy=standalone" >>/tmp/bazelrc && \

# donwload java 8 directly and extract
    wget -qO-  --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz|tar xvz

ENV JAVA_HOME /jdk1.8.0_45
ENV PATH $JAVA_HOME/bin:$PATH

# build bazel from src (tag: 0.5.0 from https://github.com/bazelbuild/bazel/releases)
RUN git clone https://github.com/google/bazel.git /bazel && cd /bazel && git checkout 0.5.0 &&\
        BAZELRC=/tmp/bazelrc /bazel/compile.sh && \

ENV PATH $PATH:/bazel/output/

# config the bazel command complete
RUN cd /bazel && \
    bazel --bazelrc=/tmp/bazelrc build //scripts:bazel-complete.bash && \
    cp bazel-bin/scripts/bazel-complete.bash /etc/bash_completion.d && \

# create bazelrc
    cd ~ && \
    echo "build:arm --crosstool_top=//tools:toolchain --cpu=armeabi-v7a" >>.bazelrc && \
    echo "build:i686 --crosstool_top=//tools:toolchain --cpu=i686" >>.bazelrc && \
    echo "build:x86_64 --crosstool_top=//tools:toolchain --cpu=x86_64" >>.bazelrc && \

# run bazel to avoid "Extracting Bazel installation..."
    bazel