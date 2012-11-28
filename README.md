Continuous integration scripts for iOS apps
============
---
# About
This script for:

* build target or scheme (compatible with [cocoapods](https://github.com/CocoaPods/CocoaPods))
* build and run [cedar](https://github.com/pivotal/cedar) tests
* build and run [calabash-iOS](https://github.com/calabash/calabash-ios) tests

# Installation
Just run command

`gem install ios_ci`

# Using

`ios_ci Action ProjectOptions`

###### Action

*  **build** - build project
*  **cedar** - build and run cedar-tests
*  **calabash** - build and run calabash-tests

###### Project Options

*  **--source-root** - path to project source code directory (_required_)
*  **--target** - project target name (_required if no scheme and workspace specified_)
*  **--scheme** - project build scheme (_required if no target specified_)
*  **--workspace** - project worspace (_required id no target specified_)
*  **--configuration** - Release, Debug (_optional, default: Release_)
*  **--architecture** - iphoneos, iphonesimulator (_optional, default: iphonesimulator_)
*  **--sdk** - version (_optional, default: latest_)
*  **--family** - iphone, ipad (_optional, default: iphone_)
*  **--build-path** - relative path from source root to app build (_optional, default: $source-root/build/_)
*  **--log-file** - path to log file (_optional, default: /tmp/$action-$target-$timestamp.log_)
