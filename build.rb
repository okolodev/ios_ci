#!/usr/bin/ruby
require "classes/params.rb"
require "classes/launcher.rb"
require "classes/build_command.rb"

BUILD_USAGE =
"Usage:
If you building target from XCode project, you should specify target name:
    build.rb --source-root source_path --target project_target [ --sdk sdk ]\
 [ --family device_family ] [ --configuration config ] [ --arch arch ]\
 [ --build_path build-dir_path ]

If you building scheme from workspace, you should specify build scheme and workspace:
    build.rb --source-root source_path --scheme build_scheme --workspace workspace_name\
 [ --sdk sdk ] [ --family device_family ] [ --configuration config ] [ --arch arch ]\
 [--build_path build-dir_path ] 

	   --source-root: project source directory
	   --arch: iphoneos, iphonesimulator
	     default: iphonesimulator
	   --configuration: Release, Debug
	     default: Debug
	   --sdk: version
	     default: latest
	   --family: iphone, ipad
	     default: iphone
	   --build-path: relative path to app build
	     default: source_path/build/"

params = Params.new(BUILD_USAGE)  
launcher = Launcher.new
launcher.run([BuildCommand], params)
if launcher.success?
  puts "Target build succeeded"
  exit 0
elsif
  puts "Target build failed"
  exit 1
end
