FROM openjdk:8
# Bazel uses jdk8. Importing jdk8 image in advance, docker runs faster.
# but there are some problem between openjdk8 and Bazel 0.5.3.

MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# To install Bazel, see https://docs.bazel.build/versions/master/install-ubuntu.html#install-with-installer-ubuntu
RUN apt-get update \
  && apt-get install -y pkg-config zip g++ zlib1g-dev unzip \
  && wget https://github.com/bazelbuild/bazel/releases/download/0.16.1/bazel-0.16.1-installer-linux-x86_64.sh \
  && chmod +x ./bazel-0.16.1-installer-linux-x86_64.sh \
  && ./bazel-0.16.1-installer-linux-x86_64.sh \

# run bazel test
  && ls -l bin/ \
  && export PATH="$PATH:/root/bin" \
  && echo $PATH \
  && which bazel \
  && bazel \
  && echo "export PATH=\$PATH:/root/bin" >> /root/.bash_profile \
  && echo "exec /bin/bash" >> /root/.bash_profile \
  && . /root/.bash_profile

# Set up workspace
WORKDIR /home
