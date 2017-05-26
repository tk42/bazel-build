#!/bin/sh

# install curl for fetching bazel, git for fetching code
apt-get install -y curl git
# install prerequisites of bazel
apt-get install -y pkg-config zip g++ zlib1g-dev unzip
rm -rf /var/lib/apt/lists/*

curl -L \
  https://github.com/bazelbuild/bazel/releases/download/0.5.0/bazel-0.5.0-installer-linux-x86_64.sh \
  -o bazel-install.sh
chmod 700 bazel-install.sh
./bazel-install.sh --user
rm bazel-install.sh

# we use this to avoid using --privileged flag
echo "startup --batch\n\
build --spawn_strategy=standalone --genrule_strategy=standalone"\
> /root/.bazelrc

# run bazel to avoid "Extracting Bazel installation..."
/root/bin/bazel