#!/usr/bin/env bash

temp=".temp_for_clang_format"
header="header"
flag=0

function foo() {
	name=$1
	regex1="^//.*"
	regex2="/\*.*"
	regex3="\*.*"

	if [[ $(cat ${name} | head -n 1)x =~ ${regex1} ]]; then
		sed -i '' '1d' "${name}"
		foo ${name}
	fi

	if [[ $(cat ${name} | head -n 1)x =~ ${regex2} ]]; then
		sed -i '' '1d' "${name}"
		foo ${name}
	fi

	if [[ $(cat ${name} | head -n 1)x =~ ${regex3} ]]; then
		sed -i '' '1d' "${name}"
		foo ${name}
	fi
}

if [ -e ${temp} ]; then
	rm ${temp}
fi

if [ -e ${header} ]; then
	flag=1
else
	echo "//******************************************************************************" >>${header}
	echo "//" >>${header}
	echo "// Copyright (c) 2018 WANG,Jingkai. All rights reserved." >>${header}
	echo "//" >>${header}
	echo "// This code is licensed under the MIT License (MIT)." >>${header}
	echo "//" >>${header}
	echo "// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >>${header}
	echo "// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >>${header}
	echo "// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >>${header}
	echo "// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >>${header}
	echo "// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >>${header}
	echo "// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN" >>${header}
	echo "// THE SOFTWARE." >>${header}
	echo "//" >>${header}
	echo "//******************************************************************************" >>${header}
fi

find . -name "*.h" >${temp}
find . -name "*.cpp" >>${temp}

while read line; do
	foo ${line}

	wait

	cp ${line} "${line}.ori"
	cat ${header} >"${line}"
	cat "${line}.ori" >>"${line}"
	rm "${line}.ori"

	clang-format -i ${line}
done <${temp}

if [ -e ${temp} ]; then
	rm ${temp}
fi

if [ ${flag} -eq 0 -a -e ${header} ]; then
	rm ${header}
fi
