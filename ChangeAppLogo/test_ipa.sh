#!/bin/sh

# 在项目里的RunScript 运行本脚本即可
#蒲公英的api_key 参考https://www.pgyer.com/doc/view/api
api_key=''

AppPath=`echo ${BUILD_DIR}/*/*.app`
AppName_all=${AppPath##*/}
AppName=${AppName_all%.*}

cd ~/Desktop
ipa_dir="output_ipa"
mkdir -p $ipa_dir
cd $ipa_dir
mkdir -p Payload
cp -Rf $AppPath ./Payload/
zip -qryX ./$AppName.ipa  ./Payload
rm -rf Payload

cd $ipa_dir
curl -F 'file=@'$AppName.ipa -F '_api_key='$api_key https://www.pgyer.com/apiv2/app/upload
rm -rf $ipa_dir
osascript -e "display notification \"测试包ipa已上传成功\" with title \"通知\" subtitle \"🚀🚀🚀\" sound name \"Funk\""
# 此处可解析返回的json 或者 通过webhook发送到钉钉或者飞书等

<<EOF
{
    "code":0,
    "message":"",
    "data":{
        "buildKey":"xxx",
        "buildType":"1",
        "buildIsFirst":"0",
        "buildIsLastest":"1",
        "buildFileKey":"xxx.ipa",
        "buildFileName":"xxx.ipa",
        "buildFileSize":"1395998",
        "buildName":"xxx",
        "buildVersion":"1.0",
        "buildVersionNo":"1",
        "buildBuildVersion":"1",
        "buildIdentifier":"com.xxx.demo",
        "buildIcon":"xxx",
        "buildDescription":"",
        "buildUpdateDescription":"",
        "buildScreenshots":"",
        "buildShortcutUrl":"aDTE",
        "buildCreated":"2022-01-31 10:08:52",
        "buildUpdated":"2022-01-31 10:08:52",
        "buildQRCodeURL":"https:\/\/www.pgyer.com\/app\/qrcodeHistory\/xxx"
    }
}
EOF





