#!/usr/bin/ruby
require "classes/params.rb"
require "classes/launcher.rb"
require "classes/build_command.rb"
require "classes/cedar_command.rb"

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
launcher = Launcher.new
launcher.run([BuildCommand.new(params), CedarCommand.new(params)])
if launcher.success? 
  puts "Cedar tests succeeded" 
  exit 0 
elsif
  puts "Cedar tests failed"
  exit 1
end
