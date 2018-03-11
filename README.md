# Tekin 定制的精简容器基础包

基于官方最新版 debian:9-slim 镜像定制

定制安装软件如下：

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
        && apt-get update && apt-get install -y gcc g++ make cmake autoconf libssl-dev  libcurl4-openssl-dev libxslt-dev libicu-dev  libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libsasl2-dev libevent-dev libpcre3-dev libgpgme11-dev pkg-config patch libgpgme11-dev && rm -rf /var/lib/apt/lists/* \
		
		此处放相应的编译安装代码，注意使用 && 连接代码， 使用 \ 换行

		#remove build deps
        && apt-get purge -y --auto-remove gcc g++ make cmake autoconf libssl-dev  libcurl4-openssl-dev libxslt-dev libicu-dev  libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libsasl2-dev libevent-dev  libpcre3-dev libgpgme11-dev pkg-config patch libgpgme11-dev \
        && apt-get clean && apt-get autoclean \
        #删除工作目录的编译包
        && cd /tmp/  &&  rm -rf /tmp/* 

***

#安装必备的基础软件包
RUN set -x \
        && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
        && apt-get update \
        # && apt-get install -y perl --no-install-recommends \
        && apt-get install -y wget unzip bzip2 psmisc binutils ca-certificates openssl curl libpcre3 libxml2 libfreetype6 sendmail --no-install-recommends \ 
        && rm -rf /var/lib/apt/lists/* 
        
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

