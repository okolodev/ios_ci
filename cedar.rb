#!/usr/bin/ruby
require "getoptlong"

getoptlong = GetoptLong.new(
   [ '--sdk',   '-s', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--target',  '-t', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--scheme',  '-h', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--workspace',  '-w', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--configuration', '-c', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--log-file', '-l', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--source-root', '-r', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--arch', '-a' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--family', '-f' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--build-path', '-b' ,GetoptLong::REQUIRED_ARGUMENT ]
)

def printUsage()
	puts "Usage:"
	puts "If you building target from XCode project"
	puts "cedar.rb --source-root source_path --target project_target [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build_path build-dir_path ]"
	puts ""
	puts "If you building scheme from workspace"
	puts "cedar.rb --source-root source_path --scheme build_scheme --workspace workspace_name [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ] [--build-path build_dir_path ]"
	puts ""
        puts "  --arch: iphoneos, iphonesimulator"
        puts "    default: iphoneos"
        puts "  --configuration: Release, Debug"
        puts "    default: Release"
        puts "  --sdk: version"
        puts "    default: latest"
        puts "  --family: iphone, ipad"
        puts "    default: iphone"
        puts "  --log-file: path to log"
        puts "    default: /tmp/cedar-$target-$timestamp.log"
	puts "  --build-path: relative path to app build"
	puts "    default: source_path/build/"
end

BUILD_SCHEME = "scheme"
BUILD_TARGET = "target"
source_root = nil
target = nil
workspace = nil
scheme = nil
arch = "iphoneos"
configuration = "Release"
sdk = nil
family = nil
log_file = nil
build_dir = "build"
sim_path = "/usr/local/bin/ios-sim"
build_type = nil;

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
      when "--log-file"
        log_file = arg
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

if !target.nil? and !source_root.nil?
  build_type = BUILD_TARGET
elsif !workspace.nil? and !scheme.nil?
  build_type = BUILD_SCHEME
else
  puts "You must specify target and source root or scheme and workspace"
  printUsage
  exit 1
end

build = nil
if build_type == BUILD_TARGET
  build = "-target '#{target}'"
else
 build = "-scheme '#{scheme}' -workspace '#{workspace}'"
end
cedar_test_target = "cd #{source_root} && xcodebuild #{build} -sdk #{arch} -configuration #{configuration} build"
puts cedar_test_target
cedar_test_target_exit_code = system(cedar_test_target)

if cedar_test_target_exit_code
  puts "Cedar tests build succeeded"
  puts
else
  puts "Cedar tests build failed"
  exit 1
end

log_file = "/tmp/cedar-#{target}-#{Time.now.to_i}.log" if log_file.nil?
app_name = nil
if build_type == BUILD_TARGET
  app_name = "#{target}.app"
else
  app_name = "#{scheme}.app"
end
app_path = "#{source_root}/#{build_dir}/#{configuration}-#{arch}/#{app_name}"

%x[ killall "iPhone Simulator" ]

puts ">>>>>>>>>#{app_path} <<<<<<<<<"
test_command = "#{sim_path} launch #{app_path} --setenv CEDAR_HEADLESS_SPECS=1 --setenv CEDAR_REPORTER_CLASS=CDRColorizedReporter,CDRJUnitXMLReporter --setenv CEDAR_JUNIT_XML_FILE=#{source_root}/test-reports/cedar.xml "
test_command + " --family #{family} " unless family.nil?
test_command + " --sdk #{sdk} " unless sdk.nil?

system("#{test_command} > #{log_file} 2>&1")

grep_exit_code = system("grep -q \"0 failures\" #{log_file}")

File.open(log_file, 'r') do |f1|
  while line = f1.gets
    puts line
  end
end

unless grep_exit_code
  exit 1
end
exit 0
