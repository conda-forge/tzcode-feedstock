set -exo pipefail

lzip -d tzdb-${PKG_VERSION}.tar.lz

if [[ $(uname) == Darwin ]]; then
  CFLAGS="$CFLAGS -DHAVE_GETRANDOM=0"
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  mkdir for_build
  pushd for_build
  tar xvf ../tzdb-${PKG_VERSION}.tar --strip 1
  make -e \
    CC=${CC_FOR_BUILD} \
    TOPDIR=${BUILD_PREFIX} \
    USRDIR="" \
    ZICDIR="${BUILD_PREFIX}/bin" \
    TZDIR="./share/zoneinfo" \
    MANDIR="./man" \
    TZDEFAULT="./etc/localtime" \
    install
  popd
  MAKE_EXTRA_ARGS="zic=${BUILD_PREFIX}/bin/zic"
fi

tar xvf tzdb-${PKG_VERSION}.tar --strip 1

make -e \
  CC=${CC} \
  TOPDIR=${PREFIX} ${MAKE_EXTRA_ARGS:-} \
  USRDIR="" \
  ZICDIR="${PREFIX}/bin" \
  TZDIR="./share/zoneinfo" \
  MANDIR="./man" \
  TZDEFAULT="./etc/localtime" \
  install
