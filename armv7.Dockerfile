# docker build . -f armv7.Dockerfile
# Use arm32v7 Debian as the base image
FROM arm32v7/debian as build

# Set environment variables to avoid user interaction during installations
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
  git \
  python3 \
  python3-pip \
  cmake \
  libsecret-1-dev \
  libpthread-stubs0-dev \
  libssl-dev \
  libsecret-1-0 \
  libglib2.0-dev \
  sudo \
  gcc-arm-linux-gnueabihf \
  g++-arm-linux-gnueabihf

# Clone the firebase C++ SDK from the repository
RUN git clone https://github.com/invertase/firebase-cpp-sdk.git /firebase-cpp-sdk

# Change directory to the cloned repository
WORKDIR /firebase-cpp-sdk

# Setup the git repository to fetch tags
RUN git remote add upstream https://github.com/firebase/firebase-cpp-sdk.git && git fetch upstream -t

# Run Python script to install prerequisites
RUN python3 scripts/gha/install_prereqs_desktop.py --gha_build --arch 'arm32' --ssl boringssl

# Install Python dependencies
COPY external/pip_requirements.txt .
RUN python3 -m pip install -r pip_requirements.txt --user --break-system-packages

# Set possible environment variables for build
ENV VCPKG_RESPONSE_FILE=/firebase-cpp-sdk/external/vcpkg__response_file.txt
ENV MATRIX_UNIQUE_NAME=debian-Release-armv7-3.8-static-c++11
ENV SDK_NAME=linux-armv7-Release-static-c++11

# Build the SDK
RUN python3 scripts/gha/build_desktop.py --arch "arm32" --config "Release" --msvc_runtime_library "static" --linux_abi "c++11" --build_dir /firebase-cpp-sdk/out-sdk --gha_build --disable_vcpkg

# Change to build output directory
WORKDIR /firebase-cpp-sdk/out-sdk

# Archive the built files
RUN find .. -type f -print > src_file_list.txt && \
  find . -type f \( -name '*.o' -or -name '*.obj' \) -print0 | xargs -0 rm -f -- && \
  tar -czhf ../firebase-cpp-sdk-${SDK_NAME}-build.tgz .

# Reset image to store just the archive.
FROM scratch
COPY --from=build /firebase-cpp-sdk/firebase-cpp-sdk-linux-armv7-Release-static-c++11-build.tgz /firebase-cpp-sdk-linux-armv7-Release-static-c++11-build.tgz
