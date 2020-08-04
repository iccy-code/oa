#!/bin/bash

if [ 0 -eq ${#} ]; then
	exit
fi

Version='Copyright (c) iccy xxxx-xxxx, GPL Open Source Software.
openall v1.5.'

if [ "${1}" = "version" ]; then
	echo -e "${Version}"
	exit
elif [ "${1}" = "help" ]; then
	echo -e "\033[1;31m$\033[0m oa <compressed-files>"
	exit
fi

# 两个参数, 第一个是字符串, 第二个是字符, 返回字符串中字符出现的最后一个位置, 参数不对返回254, 未找到返回255
LastIndexByte() {
	if [ ${#} -ne 2 -a ${#1} -ne 0 -a ${#2} -eq 1 ]; then
		return 254
	fi

	local i
	for i in $(seq $((${#1}-1)) -1 -1); do
		eval "if [ \${1:${i}:1} = ${2} ]; then
			break
		fi"
	done
	return $((${i}))
}

# gzip -d == gunzip
# bzip2 -d == bunzip2
# compress -d == uncompress
# xz -d == unxz

# .tar
# .gz
# .bz2
# .Z
# .xz
# .rar
# .zip
# .tar.gz
# .tar.bz2
# .tar.Z

tmp=${1}

Compress() {
	LastIndexByte ${tmp} "."
	local i=${?}

	case ${tmp:${i}} in
	".tar")
		tar -xvf ${tmp}
		rm ${tmp}
	;;
	".gz")
		gzip -d ${tmp}
	;;
	".bz2")
		bzip2 -d ${tmp}
	;;
	".Z")
		compress -d ${tmp}
	;;
	".xz")
		xz -d ${tmp}
	;;
	".rar")
		unrar e ${tmp}
		rm ${tmp}
	;;
	".zip")
		unzip ${tmp}
		rm ${tmp}
	;;
	*)
		echo -e "\033[1;31mdone\033[0m"
		return
	;;
	esac

	tmp=${tmp::${i}}
	
	if [ ! -e ${tmp} ]; then
		echo "File does not exist"
		return
	fi

	Compress ${tmp}
}

cp ${1} "${1}.temp"
Compress ${tmp}
mv "${1}.temp" ${1}
