#!/bin/bash 

#最后一次提交的SHA
last_git_sha=$(git log -1 --format="%h")
#当前的分支
current_git_branch=$(git symbolic-ref --short -q HEAD)

#最后一次提交的作者
git_last_commiter=$(git log -1 --pretty=format:'%an')

#最后一次提交的时间
git_last_commit_date=$(git log -1 --format='%ai')
git_last_commit_date=${git_last_commit_date%%+*}

#编译时间
build_time=`date "+%Y-%m-%d %H:%M:%S"`

#message="git_sha: ${last_git_sha}\nbranch: ${current_git_branch}\ncommiter: ${git_last_commiter}\ncommit_date: ${git_last_commit_date}\nbuildTime: ${build_time}"


item=$(cat <<EOF 
{
  "StringsTable": "detail",
  "PreferenceSpecifiers": [
    {
      "Title": "git sha",
      "Type": "PSTitleValueSpecifier",
      "DefaultValue" : "${last_git_sha}",
      "Key": "sha"
    },
     {
      "Title": "当前分支",
      "Type": "PSTitleValueSpecifier",
      "DefaultValue" : "${current_git_branch}",
      "Key": "branch"
    },
     {
      "Title": "提交者",
      "Type": "PSTitleValueSpecifier",
      "DefaultValue" : "${git_last_commiter}",
      "Key": "commiter"
    },
     {
      "Title": "提交时间",
      "Type": "PSTitleValueSpecifier",
      "DefaultValue" : "${git_last_commit_date}",
      "Key": "commit_date"
    },
     {
      "Title": "编译时间",
      "Type": "PSTitleValueSpecifier",
      "DefaultValue" : "${build_time}",
      "Key": "build_time"
    }
  ]}
EOF
)
echo $item > ./info.json
plutil -convert xml1 ./info.json -o ./gitInfo.plist
rm -rf ./info.json
mv  ./gitInfo.plist  $SRCROOT/*/Settings.bundle/ 
rm -rf ./gitInfo.plist