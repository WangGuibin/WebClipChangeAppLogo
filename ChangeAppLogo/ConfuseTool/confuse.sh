#!/usr/bin/env bash

# 注意ConfuseTool目录下的文件 不要勾选☑️target  不然会被当成资源文件加到main bundle里去的
# 调用 RunScript里 `sh $PROJECT_DIR/ConfuseTool/confuse.sh` 即可
# 生成之后 在pch中导入或者在使用到的地方导入 #import "codeObfuscation.h" 即可

TABLENAME=symbols
SYMBOL_DB_FILE="$PROJECT_DIR/ConfuseTool/symbols"
STRING_SYMBOL_FILE="$PROJECT_DIR/ConfuseTool/func.list"

CONFUSE_FILE="$PROJECT_DIR/ChangeAppLogo/FeatureModule" #可指定具体目录需要进行混淆的模块进行混淆 不必全局去加混淆 毕竟这个东西难调试 最好是Release发布的时候才去加 确保编译能过即可

HEAD_FILE="$PROJECT_DIR/ConfuseTool/codeObfuscation.h"

export LC_CTYPE=C

#取以.m或.h结尾的文件以+号或-号开头的行 |去掉所有+号或－号|用空格代替符号|n个空格跟着<号 替换成 <号|开头不能是IBAction|用空格split字串取第二部分|排序|去重复|删除空行|只匹配指定前缀开头"wgb_"的行>写进func.list
grep -h -r -I  "^[-+]" $CONFUSE_FILE  --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"| sed "/^[ ]*IBAction/d"|awk '{split($0,b," "); print b[2]; }'| sort|uniq |sed "/^$/d"|sed -n "/^wgb_/p" > $STRING_SYMBOL_FILE


#维护数据库方便日后作排重,以下代码来自念茜的博客
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-z_A-Z' |head -c 16

}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE


sqlite3 $SYMBOL_DB_FILE .dump

