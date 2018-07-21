FROM ubuntu:16.04
FROM python:latest
# Bazel uses jdk8. Importing jdk8 image in advance, docker runs faster.
# but there are some problem between openjdk8 and Bazel 0.5.3.
FROM openjdk:8

MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# To install Bazel, see https://docs.bazel.build/versions/master/install-ubuntu.html#install-with-installer-ubuntu
RUN apt-get update \
  && apt-get install -y pkg-config zip g++ zlib1g-dev unzip \
  && wget https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-installer-linux-x86_64.sh \
  && chmod +x ./bazel-0.5.2-installer-linux-x86_64.sh \
  && ./bazel-0.5.2-installer-linux-x86_64.sh \

# run bazel test
  && ls -l bin/ \
  && export PATH="$PATH:/root/bin" \
  && echo $PATH \
  && which bazel \
  && bazel \
  && echo "export PATH=\$PATH:/root/bin" >> /root/.bash_profile \
  && echo "alias python='/usr/bin/python3'" >> /root/.bash_profile \
  && echo "exec /bin/bash" >> /root/.bash_profile \
  && . /root/.bash_profile

# Install basic commands
RUN apt-get install -y make vim less
RUN apt-get install -y libatlas-base-dev libatlas-doc libopenblas-base libopenblas-dev

# Install python modules
RUN apt-get install -y python3-pip python3-dev\
  && pip3 install --upgrade pip
RUN pip install numpy==1.14.3 scipy==1.1.0 setuptools ccxt==1.13.76 \
  && six==1.10.0 pytz==2017.2 munch==2.1.1 pypandoc==1.4 logutils==0.3.5 \
  && requests==2.18.4 aiohttp==3.0.5 ta==0.1.5 multiprocessing-logging==0.2.5 \
  && sqlite3worker==1.1.7 mock==2.0.0 boto3==1.7.40 importlib==1.0.4 awscli==1.15.59
RUN pip install -U python-dateutil deribit-api

# Install other modules
RUN apt-get install -y pandoc sqlite3

# Set up workspace
ENV LOCAL_DIST_DIR /home/workspace
WORKDIR /home
