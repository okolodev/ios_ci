#!/usr/bin/ruby
require "getoptlong"

getoptlong = GetoptLong.new(
   [ '--sdk',   '-s', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--target',  '-t', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--configuration', '-c', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--log-file', '-l', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--source-root', '-r', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--arch', '-a' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--family', '-f' ,GetoptLong::REQUIRED_ARGUMENT ]

)

def printUsage()
	puts "Usage:"
	puts "cedar.rb --source-root source_path --target project_target [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ]"
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
end

source_root = nil
target = nil
arch = "iphoneos"
configuration = "Release"
sdk = nil
family = nil
log_file = nil
sim_path = "/usr/local/bin/ios-sim"

begin
  getoptlong.each do |opt, arg|
    case opt
      when "--source-root"
        source_root = arg
      when "--target"
        target = arg
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
    end
  end
rescue StandardError=>my_error_message
	puts
	puts my_error_message
	printUsage()
	puts
	exit 1
end

if target.nil? or source_root.nil?
  puts "You must specify target and source root"
  printUsage
  exit 1
end

cedar_test_target = "cd #{source_root} && xcodebuild -target '#{target}' -sdk #{arch} -configuration #{configuration} build"
cedar_test_target_exit_code = system(cedar_test_target)

if cedar_test_target_exit_code
  puts "Cedar tests build succeeded"
  puts
else
  puts "Cedar tests build failed"
  exit 1
end

log_file = "/tmp/cedar-#{target}-#{Time.now.to_i}.log" if log_file.nil?
app_path = "#{source_root}/build/#{configuration}-#{arch}/#{target}.app"

%x[ killall "iPhone Simulator" ]

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
