#!/bin/bash

set -e

BUILD_DIR="/home/warfront1/clonezilla-docker-build/"
FILE="clonezilla.iso"
URL="https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/3.1.3-16/clonezilla-live-3.1.3-16-amd64.iso"
MNT_DIR="rootfs"
UNSQUASH_DIR="unsquashfs"

for arg in "$@"
do
 case $arg in
  --dir=*)
  BUILD_DIR="${arg#*=}"
  shift
  ;;
  --url=*)
  URL="${arg#*=}"
  shift
  ;;
 esac
done

PREFIX="clonezilla-live-"
SUFFIX=".iso"
VERSION=${URL#*$PREFIX}
VERSION=${VERSION%"$SUFFIX"}
echo "Starting the build process for Clonezilla version: $VERSION"

cd $BUILD_DIR
pwd

if [ ! -f "$FILE" ]; then
    wget -O ${FILE} ${URL}
else
    echo "File ${FILE} already exists."
fi

if [ -d "${UNSQUASH_DIR}" ]; then
    echo "Directory '${UNSQUASH_DIR}' exists and will be deleted."
    rm -rf "${UNSQUASH_DIR}"
fi
mkdir -p $MNT_DIR "${UNSQUASH_DIR}"

if mountpoint -q ${MNT_DIR}
then
    echo "${MNT_DIR} is a mountpoint, unmounting..."
    umount ${MNT_DIR} || {
        echo "Unmount failed, trying to kill processes..."
        fuser -km ${MNT_DIR}
        umount ${MNT_DIR}
    }
fi

mount -o loop $FILE $MNT_DIR
#find . -type f -name filesystem.squashfs -print0 | xargs -r0 unsquashfs -f -d "${UNSQUASH_DIR}/" -ig -no-exit
find . -type f -name filesystem.squashfs -print0 | xargs -r0 unsquashfs -f -d "${UNSQUASH_DIR}/"
pwd
IMAGE_ID=$(tar -C "${UNSQUASH_DIR}" -c . | docker import - warfront1/clonezilla)

sleep 5s
DOCKERFILE_PATH="./Dockerfile-tmp"
# Create temporary Dockerfile
echo "FROM warfront1/clonezilla:latest" > $DOCKERFILE_PATH
echo "LABEL version=\"${VERSION}\"" >> $DOCKERFILE_PATH

# Build Docker image from Dockerfile and set the tag
docker build --file $DOCKERFILE_PATH --tag warfront1/clonezilla:${VERSION} .

# We can remove this Dockerfile after using it
rm $DOCKERFILE_PATH

echo "Clonezilla Docker image version $VERSION has been created"

docker tag warfront1/clonezilla:${VERSION} warfront1/clonezilla:latest
echo "Clonezilla Docker image additionally tagged as latest"