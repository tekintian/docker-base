FROM debian:9-slim

MAINTAINER Tekin Tian <tekintian@gmail.com>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r www && useradd -r -g www -M -s /sbin/nologin www

ENV RUN_USER=www \
    LIBICONV_VERSION=1.15 \
    CURL_VERSION=7.58.0 \
    LIBMCRYPT_VERSION=2.5.8 \
    MHASH_VERSION=0.9.9.9 \
    MCRYPT_VERSION=2.6.8 \
    JEMALLOC_VERSION=5.0.1 \
    GOSU_VERSION=1.10

WORKDIR /tmp
# ADD src/ /tmp/
#安装必备的软件包
RUN set -x \
        && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
        && apt-get update \
        && apt-get install -y wget gnupg dirmngr unzip bzip2 psmisc sendmail binutils ca-certificates openssl  curl libpcre3 libxml2 libfreetype6 --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* 
# add gosu for easy step-down from root
RUN set -x \
        && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
        && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
        && export GNUPGHOME="$(mktemp -d)" \
        && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
        && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
        && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu \
        && gosu nobody true
#add diy lib
RUN set -x \
        # && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
        #install deps
        # && apt-get update && apt-get install -y ca-certificates wget --no-install-recommends && rm -rf /var/lib/apt/lists/* \
         #wget src
        && wget -c --no-check-certificate http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz \
        && wget -c --no-check-certificate https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz \
        && wget -c --no-check-certificate http://downloads.sourceforge.net/project/mhash/mhash/${MHASH_VERSION}/mhash-${MHASH_VERSION}.tar.gz \
        && wget -c --no-check-certificate http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/${LIBMCRYPT_VERSION}/libmcrypt-${LIBMCRYPT_VERSION}.tar.gz \
        && wget -c --no-check-certificate http://downloads.sourceforge.net/project/mcrypt/MCrypt/${MCRYPT_VERSION}/mcrypt-${MCRYPT_VERSION}.tar.gz \
        && wget -c --no-check-certificate https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
        # #remove deps
        # && apt-get purge -y --auto-remove ca-certificates wget \
        #install make deps
        && apt-get update && apt-get install -y gcc g++ make cmake autoconf libssl-dev  libcurl4-openssl-dev libxslt-dev libicu-dev  libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libsasl2-dev libevent-dev libpcre3-dev libgpgme11-dev pkg-config patch libgpgme11-dev && rm -rf /var/lib/apt/lists/* \
        #libiconv
        && tar xzf libiconv-${LIBICONV_VERSION}.tar.gz \
        && cd libiconv-${LIBICONV_VERSION}  \
        &&  ./configure --prefix=/usr/local  \
        && make && make install \
        && cd /tmp/ \
        # install curl
        && tar xzf curl-${CURL_VERSION}.tar.gz  \
        && cd curl-${CURL_VERSION}  \
        &&  ./configure --prefix=/usr/local \
        && make && make install  \
        && cd /tmp/ \
        # install mhash
        &&  tar xzf mhash-${MHASH_VERSION}.tar.gz \
        &&  cd mhash-${MHASH_VERSION} \
        &&  ./configure \
        &&  make && make install \
        && cd /tmp/  \
        # install libmcrypt
        &&  tar xzf libmcrypt-${LIBMCRYPT_VERSION}.tar.gz  \
        && cd libmcrypt-${LIBMCRYPT_VERSION}  \
        && ./configure  \
        && make && make install  \
        && ldconfig  \
        && cd libltdl  \
        && ./configure --enable-ltdl-install  \
        && make && make install  \
        && cd /tmp/ \
        # install mcrypt
        &&   tar xzf mcrypt-${MCRYPT_VERSION}.tar.gz  \
        &&  cd mcrypt-${MCRYPT_VERSION}  \
        &&   ldconfig  \
        &&  ./configure  \
        &&  make && make install  \
        && cd /tmp/ \
        # install jemalloc
        # 查看jemalloc状态  lsof -n | grep jemalloc
        && tar xjf jemalloc-${JEMALLOC_VERSION}.tar.bz2  \
        && cd jemalloc-${JEMALLOC_VERSION}  \
        && ./configure  \
        && make && make install  \
        && echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf  \
        && ldconfig \
        #remove build deps
        && apt-get purge -y --auto-remove gcc g++ make cmake autoconf libssl-dev  libcurl4-openssl-dev libxslt-dev libicu-dev  libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libsasl2-dev libevent-dev  libpcre3-dev libgpgme11-dev pkg-config patch libgpgme11-dev \
        #将阿里的镜像换回默认镜像
        # && sed -i 's/mirrors.aliyun.com/deb.debian.org/g' /etc/apt/sources.list \
        && apt-get clean && apt-get autoclean \
        && cd /tmp/  &&  rm -rf /tmp/*