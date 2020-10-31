fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios lint
```
fastlane ios lint
```

### ios tests
```
fastlane ios tests
```
Runs all the tests
### ios beta
```
fastlane ios beta
```

### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios screenshot
```
fastlane ios screenshot
```

### ios register_uuid
```
fastlane ios register_uuid
```
Register device to develop center.
### ios analyze
```
fastlane ios analyze
```
Runs linting (and eventually static analysis)
### ios release_build
```
fastlane ios release_build
```
打生产包，打包后会自动打开文件夹
### ios firim_for_release
```
fastlane ios firim_for_release
```
打测试包，打包后会自动上传到蒲公英
### ios upload_ipa_to_firim
```
fastlane ios upload_ipa_to_firim
```
Submit a new version to Firim

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
