#!/bin/bash

set -eu

SCRIPT_DIR=$(cd "$(dirname "$BASH_SOURCE")" ; pwd)
SCRIPT_NAME=$(basename "$BASH_SOURCE")

# https://stackoverflow.com/questions/23513045/how-to-check-if-a-process-is-running-inside-docker-container
if ! $(grep -q "/docker/" /proc/1/cgroup); then

  ##############################################################################
  # host commands
  ##############################################################################

  ImageName=build_linux_toolchain

  echo docker run -t --name ${ImageName} -v "${SCRIPT_DIR}:/src" centos:7 /src/${SCRIPT_NAME}
  docker run -t --name ${ImageName} -v "${SCRIPT_DIR}:/src" centos:7 /src/${SCRIPT_NAME}

  echo Removing ${ImageName}...
  docker rm ${ImageName}
  DOCKER_BUILD_DIR=/src/build

  if [ $UID -eq 0 ]; then
    ##############################################################################
    # docker root commands
    ##############################################################################
    yum install -y epel-release centos-release-scl dnf dnf-plugins-core

	# needed for mingw due to https://pagure.io/fesco/issue/2333
	dnf -y copr enable alonid/mingw-epel7

    yum install -y ncurses-devel patch llvm-toolset-7 llvm-toolset-7-llvm-devel make cmake3 tree zip \
        git wget which gcc-c++ gperf bison flex texinfo bzip2 help2man file unzip autoconf libtool \
        glibc-static libstdc++-devel libstdc++-static mingw64-gcc mingw64-gcc-c++ mingw64-winpthreads-static \
		devtoolset-7-gcc libisl-devel

	export MANPATH=""

	# cannot use this normal method as it creates its own bash, so lets just sorce the env
	# scl enable devtoolset-7 bash
	source /opt/rh/devtoolset-7/enable

	unset LD_LIBRARY_PATH

    # Create non-privileged user and workspace
    adduser buildmaster
    mkdir -p ${DOCKER_BUILD_DIR}
    chown buildmaster:nobody -R ${DOCKER_BUILD_DIR}

    exec su buildmaster "$0"
  fi

fi
