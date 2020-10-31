#!/bin/sh

# optional, to prevent versioning for release builds
if [[ $CONFIGURATION == "Release" ]]; then
    exit 0
fi

export PATH=/opt/local/bin/:/opt/local/sbin:$PATH:/usr/local/bin:

convertPath=`which convert`
gsPath=`which gs`

if [[ ! -f ${convertPath} || -z ${convertPath} ]]; then
  convertValidation=true;
else
  convertValidation=false;
fi

if [[ ! -f ${gsPath} || -z ${gsPath} ]]; then
  gsValidation=true;
else
  gsValidation=false;
fi

if [[ "$convertValidation" = true || "$gsValidation" = true ]]; then
  echo "WARNING: Skipping Icon versioning, you need to install ImageMagick and ghostscript (fonts) first, you can use brew to simplify process:"

  if [[ "$convertValidation" = true ]]; then
    echo "brew install imagemagick..."
    brew install imagemagick
  fi
  if [[ "$gsValidation" = true ]]; then
    echo "brew install ghostscript..."
    brew install ghostscript
  fi
exit 0;
fi

VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`
BUILD_NUMBER=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`

# Check if we are under a Git or Hg repo
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    COMMIT=`git rev-parse --short HEAD`
    BRANCH=`git rev-parse --abbrev-ref HEAD`
else
    COMMIT=`hg identify -i`
    BRANCH=`hg identify -b`
fi;

#SRCROOT=..
#CONFIGURATION_BUILD_DIR=.
#UNLOCALIZED_RESOURCES_FOLDER_PATH=.

#VERSION="3.4"
#BUILD_NUMBER="9999"
#COMMIT="3783bab"
#BRANCH="master"

# optional, to fix fastlane warnings that show up in the Report navigator
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

function generateIcons() {
  export GEM_HOME=~/.rbenv/shims
  export PATH=$PATH:$GEM_HOME
  export FASTLANE_DISABLE_COLORS=1 # optional, to remove from the build log the ANSI escape sequences that enables colors in terminal
  export FASTLANE_SKIP_UPDATE_CHECK=1 # optional, to make sure that the versioning finishes as fast as possible in case there is an available update
  export FASTLANE_HIDE_GITHUB_ISSUES=1 # optional, to make sure that the versioning finishes as fast as possible in case the plugin crashes

  bundle exec fastlane run version_icon appiconset_path:'ChangeAppLogo/Assets.xcassets/AppIcon.appiconset' text:"$VERSION($BUILD_NUMBER)\n $COMMIT\n $BRANCH"
}

# make sure Bundler is found
if command -v git >/dev/null 2>&1; then 
  generateIcons
else
  echo "bundle not found！！！"
  exit 0
fi
