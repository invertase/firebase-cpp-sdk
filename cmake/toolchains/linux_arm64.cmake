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

# Toolchain file for building ARMv8 applications
# set (CMAKE_POSITION_INDEPENDENT_CODE ON)
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=armv8-a -fPIC")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8-a -fPIC -std=c++11")

# # Set the library and include paths
# set(CMAKE_LIBRARY_PATH "/usr/lib/aarch64-linux-gnu")
# set(INCLUDE_DIRECTORIES ${INCLUDE_DIRECTORIES} "/usr/include/aarch64-linux-gnu")

# # Adjust PKG_CONFIG_PATH for cross-compilation
# set(ENV{PKG_CONFIG_PATH} "/usr/lib/aarch64-linux-gnu/pkgconfig:$ENV{PKG_CONFIG_PATH}")

