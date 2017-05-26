FROM ubuntu:14.04
MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

COPY install_bazel.sh /root/
COPY install_python.sh /root/

# install bazel and it's dependencies
RUN cd /root \
  && ./install_bazel.sh && rm install_bazel.sh \
  && ./install_python.sh && rm install_python.sh