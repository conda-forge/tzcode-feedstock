lzip -d tzdb-${PKG_VERSION}.tar.lz
tar xvf tzdb-${PKG_VERSION}.tar --strip 1

make -e \
  cc=${CC} \
  TOPDIR=${PREFIX} \
  USRDIR="" \
  install

mv ${PREFIX}/sbin/zic ${PREFIX}/bin
