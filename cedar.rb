#!/usr/bin/ruby
require "classes/params.rb"
require "classes/builder.rb"
require "classes/cedar_tester.rb"

CEDAR_USAGE = 
"Usage:
If you testing target from XCode project:
    cedar.rb --source-root source_path --target project_target [ --sdk sdk]\
 [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ]\
 [--build_path build-dir_path ]

If you testing scheme from workspace:
    cedar.rb --source-root source_path --scheme build_scheme --workspace workspace_name\
 [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch]\
 [ --log-file log_path ] [--build-path build_dir_path ]

    --arch: iphoneos, iphonesimulator
      default: iphoneos
    --configuration: Release, Debug
      default: Release
    --sdk: version
      default: latest
    --family: iphone, ipad
      default: iphone
    --log-file: path to log
      default: /tmp/cedar-$target-$timestamp.log
    --build-path: relative path to app build
      default: source_path/build/"

params = Params.new(CEDAR_USAGE)
builder = Builder.new(params)
builder.run

if builder.success? 
  cedar = CedarTester.new(params)
  cedar.run
  exit cedar.success? ? 0 : 1
elsif
  exit 1
end
