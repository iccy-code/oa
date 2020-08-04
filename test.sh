#!/bin/bash

# 解压测试包
./openall.sh test.tar.Z.xz.rar.zip.gz.bz2 > /dev/null 2>&1
cd test

# 解压所有测试文件
file=""
for file in ./*; do
	# stderr和stdout同时重定向, 不同于单个重定向, 源 > 目, 它是源 > 目 2>&1, 将源的stderr和stdout合并了, 再输出到目中
	../openall.sh ${file} > /dev/null 2>&1
done
unset file

# 解压出来的文件列表
fileLists=(`ls`)

# 正确的文件列表
correctLists="bzip2 compress gzip rar tar xz zip"

# 测试开始
i=0
for correst in ${correctLists}; do
	if [ ${correst} = ${fileLists[i]} ]; then
		i=$((${i}+2))
		continue
	fi
	i=$((${i}+1))
	echo -e "Unable to unzip the file in this format \033[01;31m${correst}\033[0m"
done
unset i

echo -e "--\033[01;31mPASS\033[0m"

cd ..
rm -r test

# 傻逼, 脑残, 没想清楚就开始写代码, 浪费个把小时, 想清楚再写只花了5分钟, 思考了三分钟, 省了三分钟浪费了个把小时
# for ((i=0; i<${#fileLists[@]}; i++));do
# # echo ${fileLists[i]}

# 	# eval "if [ ${i} -eq $((${#fileLists[@]}-1)) -a ${fileLists[i]} != \${fileLists[i-1]::${#fileLists[i]}} ]; then
# 	# 	echo zip
# 	# fi"
# 	if [ ${i} -eq $((${#fileLists[@]}-1)) ]; then
# 		echo "fewfesefwfaqwrfgw"
# 	fi

# 	eval "if [ [ ${i} -eq $((${#fileLists[@]}-1)) -a ${fileLists[i]} != \${fileLists[i-1]::${#fileLists[i]}} ] -o ${fileLists[i]} = \${fileLists[i+1]::${#fileLists[i]}} ]; then
# 		# echo ${fileLists[i]}
# 		i=$((${i}+1))
# 		continue
# 	fi"
# 	LastIndexByte ${fileLists[i]} "."
# 	echo -e "Unable to unzip the file in this format \033[01;31m${fileLists[i]::${?}}\033[0m"
# done

# loacl i=0
# while ((i<14)); do
# 	eval "if [ \${fileLists[i]} = \${fileLists[i+1]::${#fileLists[i]}} ]; then
# 		i=$((${i}+2))
# 		continue
# 	fi"
# 	echo ${fileLists[i]}
# 	i=$((${i}+1))
# done