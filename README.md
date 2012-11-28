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

*  **--source-root** - path to project source code directory (*required*)
*  **--target** - project target name (*required if no scheme and workspace specified*)
*  **--scheme** - project build scheme (*required if no target specified*)
*  **--workspace** - project worspace (*required id no target specified*)
*  **--configuration** - Release, Debug (*optional, default: Release*)
*  **--architecture** - iphoneos, iphonesimulator (*optional, default: iphonesimulator*)
*  **--sdk** - version (*optional, default: latest*)
*  **--family** - iphone, ipad (*optional, default: iphone*)
*  **--build-path** - relative path from source root to app build (*optional, default: $source-root/build/*)
*  **--log-file** - path to log file (*optional, default: /tmp/$action-$target-$timestamp.log*)
