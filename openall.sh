#!/bin/bash

if [ 0 -eq ${#} ]; then
	exit
fi

Version="v1.0"

if [ "${1}" = "version" ]; then
	echo -e "Version \033[1;31m${Version}\033[0m"
	exit
elif [ "${1}" = "help" ]; then
	echo -e "\033[1;31m$\033[0m oa <compressed-files>"
	exit
fi

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
binList="tar gzip bzip2 compress xz unrar unzip"

Compress() {
	suffix=$(echo ${tmp} | egrep '\.[targzb2Zxrip]{1,3}$' -o)

	case ${suffix} in
	".tar")
		tar -kxvf ${tmp}
		rm ${tmp}
		return
	;;
	".gz")
		gzip -vd ${tmp}
	;;
	".bz2")
		bzip2 -vd ${tmp}
	;;
	".Z")
		# echo ${suffix}098
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

	eval tmp="\${tmp%${suffix}}"
	
	if [ ! -e ${tmp} ]; then
		echo "File does not exist"
		return
	fi

	Compress ${tmp}
}

cp ${1} "${1}.temp"
Compress ${tmp}
mv "${1}.temp" ${1}