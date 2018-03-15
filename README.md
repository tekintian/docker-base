# Tekin 定制的精简容器基础包

基于官方最新版 debian:9-slim 镜像定制， 支持最新版PHP, TENGINE, NGINX编译安装。

内置系统运行库：wget, unzip, bzip2, procps, psmisc, binutils, tree, dpkg, gnupg, dirmngr, ca-certificates, openssl, libssl1.1, lua-luaossl, curl, libpcre3, libxml2, libfreetype6, libxslt1.1, libsasl2-2, libjpeg62-turbo, libevent-core-2.0-5, libgpgme11, lua-curl, libcurl3, libicu57, libgomp1 内置软件包：gosu 1.10， libiconv 1.15, curl 7.58.0, mhash 0.9.9.9, libmcrypt 2.5.8 2.6.8,  mcrypt 2.6.8, jemalloc 5.0.1 


## Change Logs

TAG版本   |    更新内容    |   更新时间    |   备注
---- | ---  |  --- |
1.1  |  add libzip4 runtime | 2018年03月15日 |   新增最新版 PHP7.3 运行支持库文件  |
1.0  |  初始版本 | 2018年03月13日 |   系统运行库：wget, unzip, bzip2, procps, psmisc, binutils, tree, dpkg, gnupg, dirmngr, ca-certificates, openssl, libssl1.1, lua-luaossl, curl, libpcre3, libxml2, libfreetype6, libxslt1.1, libsasl2-2, libjpeg62-turbo, libevent-core-2.0-5, libgpgme11, lua-curl, libcurl3, libicu57, libgomp1 最新软件包：libiconv 1.15, curl 7.58.0, mhash 0.9.9.9, libmcrypt 2.5.8 2.6.8,  mcrypt 2.6.8, jemalloc 5.0.1 gosu 1.10  |

***

定制安装软件与下载地址：

  http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
  https://curl.haxx.se/download/curl-7.58.0.tar.gz
  http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
  http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
  http://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz
  https://github.com/jemalloc/jemalloc/releases/download/5.0.1/jemalloc-5.0.1.tar.bz2


***


## 精简定制方法
***
### 精简原则： 
** 用之前安装依赖包，用完删除对应依赖包，安装和卸载必须要放到一个命令块中 ** 

-- 设定工作目录
WORKDIR /tmp

#执行一个命令块

RUN set -x \
		#修改官方源为自定义的源
        # && sed -i 's/mirrors.aliyun.com/deb.debian.org/g' /etc/apt/sources.list \
		#install build deps
        && buildDeps='\
                gcc \
                g++ \
                make \
                cmake \
                autoconf \
                libssl-dev \
                libcurl4-openssl-dev \
                libxslt-dev \
                libicu-dev \
                libxml2-dev \
                libjpeg-dev \
                libpng-dev \
                libfreetype6-dev \
                libsasl2-dev \
                libevent-dev \
                libpcre3-dev \
                libgpgme11-dev \
                pkg-config \
                patch \
                libgpgme11-dev \
                --no-install-recommends ' \
        && apt-get update && apt-get install -y ${buildDeps} && rm -rf /var/lib/apt/lists/* \


		此处放相应的编译安装代码，注意使用 && 连接代码， 使用 \ 换行

		#remove build deps
        && apt-get purge -y --auto-remove ${buildDeps} \
        && apt-get autoclean \
        #删除工作目录的编译包
        && cd /tmp/  &&  rm -rf /tmp/* 

***

#安装必备的基础软件包
RUN set -x \
        && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
        && apt-get update \
        # && apt-get install -y perl --no-install-recommends \
        && apt-get install -y wget unzip bzip2 procps psmisc binutils ca-certificates openssl curl libpcre3 libxml2 libfreetype6 sendmail --no-install-recommends \ 
        && rm -rf /var/lib/apt/lists/* 



### 安装邮件发送包 sendmail 示例【登录容器 "docker exec -it xxx bash" 后执行以下命令即可】：
apt-get update && apt-get install -y sendmail --no-install-recommends && rm -rf /var/lib/apt/lists/*


***

free top等内核命令安装包   procps 
free top 命令安装包  apt-get install procps

libgpm2 libncurses5 libncursesw5 libprocps6 libtinfo5 psmisc


apt-get install procps
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libgpm2 libncurses5 libncursesw5 libprocps6 libtinfo5 psmisc
Suggested packages:
  gpm
The following NEW packages will be installed:
  libgpm2 libncurses5 libprocps6 procps psmisc
The following packages will be upgraded:
  libncursesw5 libtinfo5


*** 
## 查找删除无用文件信息
	#删除目录 /usr/local/ 下的所有 *-debug  *_embedded 文件
	&& rm -rf /usr/local/*-debug /usr/local/mysql/bin/*_embedded \
	#查找/usr/local 目录下所有 *.a 的文件并删除
	&& find /usr/local -type f -name "*.a" -delete \

	#安装 binutils
	&& apt-get update && apt-get install -y binutils && rm -rf /var/lib/apt/lists/* \

	# && { find /usr/local -type f -executable -exec strip --strip-all '{}' + || true; } \

	#删除 binutils
	&& apt-get purge -y --auto-remove binutils \

***

## sample

	&& sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	
	code.....


	&& apt-get purge -y --auto-remove ca-certificates wget

***


 fetchDeps=' \
        ca-certificates \
        wget \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    \

	coding......

    apt-get purge -y --auto-remove $fetchDeps


## 说明： 
本包为基础定制包，需要在上面安装应用软件后才可使用。

*** 

## 查看运行日志 
docker logs <容器ID>

*** 
## 进入容器
docker exec -it <容器ID> bash

*** 
## 交流讨论
Tekin

QQ:3316872019


*** 
# tips

## 创建用户
useradd(选项)(参数)

	-c<备注>：加上备注文字。备注文字会保存在passwd的备注栏位中；
	-d<登入目录>：指定用户登入时的启始目录；
	-D：变更预设值；
	-e<有效期限>：指定帐号的有效期限；
	-f<缓冲天数>：指定在密码过期后多少天即关闭该帐号；
	-g<群组>：指定用户所属的群组；
	-G<群组>：指定用户所属的附加群组；
	-m：自动建立用户的登入目录；
	-M：不要自动建立用户的登入目录；
	-n：取消建立以用户名称为名的群组；
	-r：建立系统帐号；
	-s<shell>：指定用户登入后所使用的shell；
	-u<uid>：指定用户id。


## 查看Linux版本信息
1. 查看Linux内核版本命令
	cat /proc/version
	uname -a

2. 查看Linux系统版本的命令
	lsb_release -a
	cat /etc/issue



http://dev.yunnan.ws



# RUN set -x \
#       && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
#       && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
#       && export GNUPGHOME="$(mktemp -d)" \
#       && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#       && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#       && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#       && chmod +x /usr/local/bin/gosu \
#       && gosu nobody true


## Remove logs

apt-get purge -y --auto-remove gcc g++ make cmake autoconf libssl-dev libcurl4-openssl-dev libxslt-dev libicu-dev libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libsasl2-dev libevent-dev libpcre3-dev libgpgme11-dev pkg-config patch --no-install-recommends
Reading package lists...
Building dependency tree...
Reading state information...
The following packages will be REMOVED:
  autoconf* cmake* cmake-data* cpp* cpp-6* g++* g++-6* gcc* gcc-6*
  icu-devtools* libarchive13* libasan3* libatomic1* libcc1-0* libcilkrts5*
  libcurl4-openssl-dev* libdpkg-perl* libevent-2.0-5* libevent-dev*
  libevent-extra-2.0-5* libevent-openssl-2.0-5* libevent-pthreads-2.0-5*
  libexpat1* libfreetype6-dev* libgcc-6-dev* libgdbm3* libglib2.0-0* libgomp1*
  libicu-dev* libisl15* libitm1* libjpeg-dev* libjpeg62-turbo-dev*
  libjsoncpp1* liblsan0* liblzo2-2* libmpc3* libmpfr4* libmpx2* libpcre16-3*
  libpcre3-dev* libpcre32-3* libpcrecpp0v5* libperl5.24* libpng-dev*
  libquadmath0* libsasl2-dev* libsigsegv2* libssl-dev* libstdc++-6-dev*
  libtsan0* libubsan0* libuv1* libxml2-dev* libxslt1-dev* m4* make* patch*
  perl* perl-modules-5.24* pkg-config* zlib1g-dev*
0 upgraded, 0 newly installed, 62 to remove and 0 not upgraded.
After this operation, 310 MB disk space will be freed.
(Reading database ... 15877 files and directories currently installed.)
Removing autoconf (2.69-10) ...
Removing cmake (3.7.2-1) ...
Removing cmake-data (3.7.2-1) ...
Removing g++ (4:6.3.0-4) ...
Removing gcc (4:6.3.0-4) ...
Removing cpp (4:6.3.0-4) ...
Removing g++-6 (6.3.0-18+deb9u1) ...
Removing gcc-6 (6.3.0-18+deb9u1) ...
Removing cpp-6 (6.3.0-18+deb9u1) ...
Removing libxslt1-dev:amd64 (1.1.29-2.1) ...
Removing libxml2-dev:amd64 (2.9.4+dfsg1-2.2+deb9u2) ...
Removing libicu-dev (57.1-6+deb9u1) ...
Removing icu-devtools (57.1-6+deb9u1) ...
Removing libarchive13:amd64 (3.2.2-2) ...
Removing libstdc++-6-dev:amd64 (6.3.0-18+deb9u1) ...
Removing libgcc-6-dev:amd64 (6.3.0-18+deb9u1) ...
Removing libasan3:amd64 (6.3.0-18+deb9u1) ...
Removing libatomic1:amd64 (6.3.0-18+deb9u1) ...
Removing libcc1-0:amd64 (6.3.0-18+deb9u1) ...
Removing libcilkrts5:amd64 (6.3.0-18+deb9u1) ...
Removing libcurl4-openssl-dev:amd64 (7.52.1-5+deb9u4) ...
Removing pkg-config (0.29-4+b1) ...
Removing libdpkg-perl (1.18.24) ...
Removing libevent-dev (2.0.21-stable-3) ...
Removing libevent-2.0-5:amd64 (2.0.21-stable-3) ...
Removing libevent-extra-2.0-5:amd64 (2.0.21-stable-3) ...
Removing libevent-openssl-2.0-5:amd64 (2.0.21-stable-3) ...
Removing libevent-pthreads-2.0-5:amd64 (2.0.21-stable-3) ...
Removing libexpat1:amd64 (2.2.0-2+deb9u1) ...
Removing libfreetype6-dev (2.6.3-3.2) ...
Removing perl (5.24.1-3+deb9u2) ...
Removing libperl5.24:amd64 (5.24.1-3+deb9u2) ...
Removing libgdbm3:amd64 (1.8.3-14) ...
Removing libglib2.0-0:amd64 (2.50.3-2) ...
Removing libgomp1:amd64 (6.3.0-18+deb9u1) ...
Removing libisl15:amd64 (0.18-1) ...
Removing libitm1:amd64 (6.3.0-18+deb9u1) ...
Removing libjpeg-dev (1:1.5.1-2) ...
Removing libjpeg62-turbo-dev:amd64 (1:1.5.1-2) ...
Removing libjsoncpp1:amd64 (1.7.4-3) ...
Removing liblsan0:amd64 (6.3.0-18+deb9u1) ...
Removing liblzo2-2:amd64 (2.08-1.2+b2) ...
Removing libmpc3:amd64 (1.0.3-1+b2) ...
Removing libmpfr4:amd64 (3.1.5-1) ...
Removing libmpx2:amd64 (6.3.0-18+deb9u1) ...
Removing libpcre3-dev:amd64 (2:8.39-3) ...
Removing libpcre16-3:amd64 (2:8.39-3) ...
Removing libpcre32-3:amd64 (2:8.39-3) ...
Removing libpcrecpp0v5:amd64 (2:8.39-3) ...
Removing libpng-dev:amd64 (1.6.28-1) ...
Removing libquadmath0:amd64 (6.3.0-18+deb9u1) ...
Removing libsasl2-dev (2.1.27~101-g0780600+dfsg-3) ...
Removing m4 (1.4.18-1) ...
Removing libsigsegv2:amd64 (2.10-5) ...
Removing libssl-dev:amd64 (1.1.0f-3+deb9u1) ...
Removing libtsan0:amd64 (6.3.0-18+deb9u1) ...
Removing libubsan0:amd64 (6.3.0-18+deb9u1) ...
Removing libuv1:amd64 (1.9.1-3) ...
Removing make (4.1-9.1) ...
Removing patch (2.7.5-1+b2) ...
Removing perl-modules-5.24 (5.24.1-3+deb9u2) ...
Removing zlib1g-dev:amd64 (1:1.2.8.dfsg-5) ...
Processing triggers for libc-bin (2.24-11+deb9u1) ...
(Reading database ... 9154 files and directories currently installed.)
Purging configuration files for libglib2.0-0:amd64 (2.50.3-2) ...
Purging configuration files for cmake-data (3.7.2-1) ...
Purging configuration files for autoconf (2.69-10) ...
Purging configuration files for perl (5.24.1-3+deb9u2) ...
Purging configuration files for pkg-config (0.29-4+b1) ...
Purging configuration files for cmake (3.7.2-1) ...


