# docker build . -f arm64v8.Dockerfile
FROM arm64v8/debian as build

# Set environment variables to avoid user interaction during installations
ENV DEBIAN_FRONTEND=noninteractive

# Build python scripts require sudo bin.
RUN apt-get update && apt-get install -y sudo

# Install necessary packages
RUN sudo apt-get update && apt-get install -y \
  # Required packages to run build scripts at a minimum.
  git \
  python3 \
  python3-pip \
  cmake \
  # Libs required for compiling the SDK
  libsecret-1-dev \
  libpthread-stubs0-dev \
  libssl-dev \
  libsecret-1-0 \
  libglib2.0-dev

WORKDIR /firebase-cpp-sdk
COPY . .

# Fetch upstream tags if running from a fork.
RUN git describe --tags --abbrev=0 > /dev/null 2>&1 || (git remote add upstream https://github.com/firebase/firebase-cpp-sdk.git && git fetch upstream -t)

# Run Python script to install remaining prerequisites.
RUN python3 scripts/gha/install_prereqs_desktop.py --gha_build --arch 'arm64' --ssl boringssl

# Install Python dependencies.
COPY external/pip_requirements.txt external/pip_requirements.txt
RUN python3 -m pip install -r external/pip_requirements.txt --user --break-system-packages

# Set required environment variables for build.
ENV SDK_NAME=linux-arm64v8

# Build the SDK.
RUN python3 scripts/gha/build_desktop.py --arch "arm64" --config "Release" --msvc_runtime_library "static" --linux_abi "c++11" --build_dir /firebase-cpp-sdk/out-sdk --gha_build --disable_vcpkg

# Change to build output directory.
WORKDIR /firebase-cpp-sdk/out-sdk

# Archive the built files.
RUN find .. -type f -print > src_file_list.txt && \
  find . -type f \( -name '*.o' -or -name '*.obj' \) -print0 | xargs -0 rm -f -- && \
  tar -czhf ../firebase-cpp-sdk-${SDK_NAME}-build.tgz .

# Inspect the built libraries (for debugging/logging purposes).
RUN python3 /firebase-cpp-sdk/scripts/gha/inspect_built_libraries.py /firebase-cpp-sdk/out-sdk/

# Reset image to store just the archive.
FROM scratch
COPY --from=build /firebase-cpp-sdk/firebase-cpp-sdk-linux-arm64v8-build.tgz /build.tgz
