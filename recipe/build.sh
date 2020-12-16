set -exo pipefail

lzip -d tzdb-${PKG_VERSION}.tar.lz

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  mkdir for_build
  pushd for_build
  tar xvf ../tzdb-${PKG_VERSION}.tar --strip 1
  make -e \
    CC=${CC_FOR_BUILD} \
    TOPDIR=${BUILD_PREFIX} \
    USRDIR="" \
    install
  mv ${BUILD_PREFIX}/sbin/zic ${BUILD_PREFIX}/bin
  popd
  MAKE_EXTRA_ARGS="zic=${BUILD_PREFIX}/bin/zic"
fi

tar xvf tzdb-${PKG_VERSION}.tar --strip 1

make -e \
  CC=${CC} \
  TOPDIR=${PREFIX} ${MAKE_EXTRA_ARGS:-} \
  USRDIR="" \
  install

mv ${PREFIX}/sbin/zic ${PREFIX}/bin
