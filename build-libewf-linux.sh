#!/bin/sh
set -e

if [ "$(uname -s)" != "Linux" ]; then
    echo "this script is made for Linux, not $(uname -s)"
    exit
fi

if [ "$(uname -m)" = "x86_64" ]; then
    arch="x64"
else
    arch="x86"
fi

mkdir -p libs/x86 libs/x64
rm -rf libewf-build
cp -r libewf-src libewf-build
cd libewf-build

./configure --prefix="$PWD/tmp" --disable-static \
    --with-bzip2=no \
    --with-openssl=no \
    --with-libuuid=no \
    --with-libfuse=no

make clean
make -j4
make install-strip

cp -f tmp/lib/libewf.so.3 ../libs/$arch/libewf-Linux-${arch}.so
make distclean
rm -rf tmp

echo ""
file ../libs/$arch/libewf-Linux-${arch}.so
echo ""
LANG=C readelf -d ../libs/$arch/libewf-Linux-${arch}.so
