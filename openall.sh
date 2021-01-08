#!/bin/bash

# 判断参数长度
if [ 0 -eq ${#} ]; then
	exit
fi

# 版本信息
Version='Copyright (c) iccy xxxx-xxxx, GPL Open Source Software.
Openall v2.0'

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

Compress() {
	LastIndexByte ${tmp} "."
	local i=${?}

	case ${tmp:${i}} in
		".tar")
			# echo tar
			tar -xmf ${tmp}
			rm ${tmp}
		;;
		".gz"|".tgz")
			# echo gzip
			gzip -rd ${tmp}
			if [ -e ${tmp::${i}} ]; then
				echo ${tmp::${i}}
			fi
		;;
		".bz2"|".bz"|".tbz"|".tbz2")
			# echo bzip2
			bzip2 -d ${tmp}
		;;
		".bzip2")
			mv ${tmp} ${tmp::${i}}.bz2
			bzip2 -d ${tmp::${i}}.bz2
			# tmp=${tmp/%"bzip2"/"bz2"}
		;;
		".Z"|".taZ")
			# echo compress
			compress -d ${tmp}
		;;
		".xz"|".txz")
			# echo xz
			xz -d ${tmp}
		;;
		".rar")
			# echo rar
			unrar e ${tmp} > /dev/null 2>&1
			rm ${tmp}
		;;
		".zip")
			# echo zip
			unzip ${tmp} > /dev/null 2>&1
			rm ${tmp}
		;;
		*)
			# Todo 显示解压缩的结果
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

tmp=${1}
cp ${1} "${1}.temp"
Compress ${tmp}
mv "${1}.temp" ${1}



# 1. *.tar 用 tar –xvf 解压 --> tar -cvf 压缩后的文件名 压缩前文件名
# 2. *.gz 用 gzip -d或者gunzip 解压 --> gzip 压缩前文件名
# 3. *.tar.gz和*.tgz 用 tar –xzf 解压 --> tar -zcf 压缩后的文件名 压缩前文件名
# 4. *.bz2 用 bzip2 -d或者用bunzip2 解压 --> bzip2 -z 压缩前文件名
# 5. *.tar.bz2用tar –xjf 解压 --> tar -jcf 压缩后的文件名 压缩前文件名
# 6. *.Z 用 uncompress 解压 --> compress 压缩前文件名
# 7. *.tar.Z 用tar –xZf 解压 --> tar -Zcf 压缩后的文件名 压缩前文件名
# 8. *.rar 用 unrar e解压 --> rar a 压缩后的文件名 压缩前文件名
# 9. *.zip 用 unzip 解压 --> zip -r 压缩后的文件名 压缩前文件名

# gzip -d == gunzip
# bzip2 -d == bunzip2
# compress -d == uncompress
# xz -d == unxz

# .tar .tbz2 .tbz
# .gz
# .bz2 .bz .bzip2
# .Z
# .xz
# .rar
# .zip
# .tar.gz
# .tar.bz2
# .tar.Z
