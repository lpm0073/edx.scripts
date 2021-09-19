export DISPLAY=:0

# see: https://stackoverflow.com/questions/64963370/error-cannot-install-in-homebrew-on-arm-processor-in-intel-default-prefix-usr
# ----------------------------------
alias brew86="arch -x86_64 /usr/local/homebrew/bin/brew"
alias brewARM="/opt/homebrew/bin/brew"
alias brew="/opt/homebrew/bin/brew"

eval "$(brewARM shellenv)"

#-------------------------------------------------
#
# Individual Homebrew package configurations
#
#-------------------------------------------------

# Python 3.8
# -------------
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/python@3.8/lib"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH /opt/homebrew/opt/python@3.8/lib/pkgconfig"

# SciPy environment variables for pip installation
# --------------
export NPY_DISTUTILS_APPEND_FLAGS=1

# blis config
export LDFLAGS="$LDFLAGS -L/usr/local/opt/blis/lib"

# zlib config
# --------------
export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include"

# zstd config
# --------------
export LDFLAGS="$LDFLAGS -L/opt/homebrew/Cellar/zstd/1.5.0/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/Cellar/zstd/1.5.0/include"

# openblas config
# --------------
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/openblas/lib/pkgconfig"
export OPENBLAS="$(brewARM --prefix openblas)"
export MACOSX_DEPLOYMENT_TARGET=11.6

# openssl config
# --------------
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/openssl@1.1/include"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

# mysql-client config
# --------------
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/mysql-client/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/mysql-client/include"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/mysql-client/lib/pkgconfig"

# libxml2 config
# --------------
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libxml2/include"
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libxml2/lib/pkgconfig"

