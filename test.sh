#!/bin/bash

test() {
	cp test.tar test
	tar xvf test > /dev/null
	cd test

	for file in ./*; do
		# stderr和stdout同时重定向, 不同于单个重定向, 源 > 目, 它是源 > 目 2>&1, 将源的stderr和stdout合并了, 再输出到目中
		../openall.sh ${file} > /dev/null 2>&1 
	done

	i=0
	tmp=""
	for file in ./*; do
		if [ 0 -eq ${i} ]; then
			echo -e "\033[34m${file}\033[0m"
			tmp=${file}
			i=1
		else
			echo -e "\033[36m${file}\033[0m"
			if [ ${tmp} != ${file:0:${#tmp}} ]; then
				echo -e "\033[31mThe test case is wrong\033[0m"
			fi
			i=0
		fi
	done

	cd ..
	rm -r test
}

test