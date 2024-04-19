# Copyright 2024 Google
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Toolchain file for building ARMv7 applications
# set(CMAKE_C_SIZEOF_DATA_PTR 4)
# set(CMAKE_CXX_SIZEOF_DATA_PTR 4)
set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

# Set compiler and linker flags for ARMv7
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=armv7-a+fp")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv7-a+fp")

# Set the library and include paths
set(CMAKE_LIBRARY_PATH "/usr/lib/arm-linux-gnueabihf")
set(INCLUDE_DIRECTORIES ${INCLUDE_DIRECTORIES} "/usr/include/arm-linux-gnueabihf")

# Adjust PKG_CONFIG_PATH for cross-compilation
set(ENV{PKG_CONFIG_PATH} "/usr/lib/arm-linux-gnueabihf/pkgconfig:$ENV{PKG_CONFIG_PATH}")

