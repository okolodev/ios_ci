#!/usr/bin/ruby
require "getoptlong"

getoptlong = GetoptLong.new(
   [ '--sdk',   '-s', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--target',  '-t', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--scheme',  '-h', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--workspace',  '-w', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--configuration', '-c', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--source-root', '-r', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--arch', '-a' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--family', '-f' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--build-path', '-b' ,GetoptLong::REQUIRED_ARGUMENT ]
)

def printUsage()
	puts "Usage:"
	puts "If you building target from XCode project, you should specify target name"
	puts "build.rb --source-root source_path --target project_target [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [--build_path build-dir_path ]"
	puts ""
	puts "If you building scheme from workspace, you should specify build scheme and workspace"
	puts "build.rb --source-root source_path --scheme build_scheme --workspace workspace_name [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [--build_path build-dir_path ]" 
	puts ""
	puts "  --source-root: project source directory"
	puts "  --arch: iphoneos, iphonesimulator"
	puts "    default: iphonesimulator"
	puts "  --configuration: Release, Debug"
	puts "    default: Debug"
	puts "  --sdk: version"
	puts "    default: latest"
	puts "  --family: iphone, ipad"
	puts "    default: iphone"
	puts "  --build-path: relative path to app build"
	puts "    default: source_path/build/"

end

BUILD_SCHEME = "scheme"
BUILD_TARGET = "target"
build_type = nil;
source_root = nil
target = nil
workspace = nil
scheme = nil
arch = "iphonesimulator"
configuration = "Release"
sdk = nil
family = nil
build_dir = "build"

begin
  getoptlong.each do |opt, arg|
    case opt
      when "--source-root"
        source_root = arg
      when "--target"
        target = arg
      when "--workspace" 
	workspace = arg
      when "--scheme"
	scheme = arg
      when "--sdk"
        sdk = arg
      when "--configuration"
        configuration = arg
      when "--arch"
        arch = arg
      when "--family"
        family = arg
      when "--build-path"
	build_dir = arg
   end
  end

rescue StandardError=>my_error_message
	puts
	puts my_error_message
	printUsage()
	puts
	exit 1
end

if source_root.nil?
  puts "You must specify source root"
  exit 1
elsif !target.nil?
  build_type = BUILD_TARGET
elsif !workspace.nil? and !scheme.nil?
  build_type = BUILD_SCHEME
else
  puts "You must specify target root or scheme and workspace"
  printUsage
  exit 1
end

build = nil
if build_type == BUILD_TARGET
  build = "-target '#{target}'"
else
  build = "-scheme '#{scheme}' -workspace '#{workspace}'"
end

clean_dir = "#{source_root}/#{build_dir}/#{configuration}-#{arch}"
build_target = "cd #{source_root} && xcodebuild #{build} -sdk #{arch} -configuration #{configuration} clean build CONFIGURATION_BUILD_DIR=#{clean_dir}"
puts build_target
build_target_exit_code = system(build_target)

if build_target_exit_code
  puts "Target build succeeded"
  exit 0
else
  puts "Target build failed"
  exit 1
end
