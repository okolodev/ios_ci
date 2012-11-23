Continuous integration scripts for iOS apps
============
---
# About
There are 3 scripts:
* build target
* build target and run [cedar](https://github.com/pivotal/cedar) tests
* build target and run [calabash-iOS](https://github.com/calabash/calabash-ios) tests

# Installation
Just run command

`git clone git@github.com:okolodev/ios_ci.git`

# Using

## Building app

If you building target from XCode project, you should specify target name:

`build.rb --source-root source\_path --target project\_target [ --sdk sdk ] [ --family device\_family ] [ --configuration config ] [ --arch arch ] [ --build\_path build-dir\_path ]`
    
    If you building scheme from workspace, you should specify build scheme and workspace:

    `build.rb --source\-root source\_path --scheme build\_scheme --workspace workspace\_name [ --sdk sdk ] [ --family device\_family ] [ --configuration config ] [ --arch arch ] [--build\_path build-dir\_path ]`

    Arguments list: 
         
         *    --source-root: project source directory
         *    --arch: iphoneos, iphonesimulator (default: iphonesimulator)
         *    --configuration: Release, Debug (default: Debug)
         *    --sdk: version (default: latest)
         *    --family: iphone, ipad (default: iphone)
         *    --build-path: relative path to app build (default: source_path/build/)

## Build and run cedar tests

If you testing target from XCode project:

`cedar.rb --source-root source_path --target project_target [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build_path build-dir_path ]`

If you testing scheme from workspace:

`cedar.rb --source-root source_path --scheme build_scheme --workspace workspace_name [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build-path build_dir_path ]`

Arguments list: 
     
     *    --source-root: project source directory
     *    --arch: iphoneos, iphonesimulator (default: iphonesimulator)
     *    --configuration: Release, Debug (default: Debug)
     *    --sdk: version (default: latest)
     *    --family: iphone, ipad (default: iphone)
     *    --build-path: relative path to app build (default: source_path/build/)

## Build and run calabash-iOS test

If you testing target from XCode project:

`calabash.rb --source-root source_path --target project_target [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build_path build-dir_path ]`

If you testing scheme from workspace:

`calabash.rb --source-root source_path --scheme build_scheme --workspace workspace_name [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build-path build_dir_path ]`

Arguments list: 
     
     *    --source-root: project source directory
     *    --arch: iphoneos, iphonesimulator (default: iphonesimulator)
     *    --configuration: Release, Debug (default: Debug)
     *    --sdk: version (default: latest)
     *    --family: iphone, ipad (default: iphone)
     *    --build-path: relative path to app build (default: source_path/build/)
