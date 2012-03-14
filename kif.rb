#!/usr/bin/ruby
require "getoptlong"

source_root = nil
target = nil
arch = "iphoneos"
configuration = "Release"
submodules = "submodules"
sdk = nil
family = nil
log_file = nil
sim_path = "/usr/local/bin/ios-sim"

getoptlong = GetoptLong.new(
   [ '--sdk',   '-s', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--target',  '-t', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--configuration', '-c', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--log-file', '-l', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--source-root', '-r', GetoptLong::REQUIRED_ARGUMENT ],
   [ '--arch', '-a' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--family', '-f' ,GetoptLong::REQUIRED_ARGUMENT ],
   [ '--submodules', '-m' ,GetoptLong::REQUIRED_ARGUMENT ]
)

def printUsage
	puts "Usage:"
	puts "kif.rb --source-root source_path --target project_target [ --submodules submodules ] [ --sdk sdk] [ --family device_family ] [ --configuration config ] [ --arch arch] [ --log-file log_path ]"
        puts "  --arch: iphoneos, iphonesimulator"
        puts "    default: iphoneos"
        puts "  --configuration: Release, Debug"
        puts "    default: Release"
        puts "  --submodules: submodules directory"
        puts "    default: submodules/"
        puts "  --sdk: version"
        puts "    default: latest"
        puts "  --family: iphone, ipad"
        puts "    default: iphone"
        puts "  --log-file: path to log"
        puts "    default: /tmp/kif-$target-$timestamp.log"
end

def printLog
  end



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
      when "--submodules"
        submodules = arg
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

log_file = "/tmp/kif-'#{target}'-#{Time.now.to_i}.log" if log_file.nil?

kif = "xcodebuild  -project '#{source_root}/#{submodules}/KIF/KIF.xcodeproj' -target 'KIF' -sdk #{arch} build"
kif_exit_code = system(kif)

if kif_exit_code
  puts "KIF library build succeeded"
  puts
else
  puts "KIF library build failed"
  exit 1
end

%x[ cd #{source_root} ]
test_target = "xcodebuild -target '#{target}' -sdk #{arch} -configuration #{configuration} build"
test_target_exit_code = system(test_target)

if test_target_exit_code
  puts "KIF tests build succeeded"
  puts
else
  puts "KIF tests build failed"
  exit 1
end

app_path = "#{source_root}/build/#{configuration}-#{arch}/#{target}.app"

%x[ killall "iPhone Simulator" ]

test_command = "#{sim_path} launch '#{app_path}'"
test_command + " --family #{family} " unless family.nil?
test_command + " --sdk #{sdk} " unless sdk.nil?

system("#{test_command} > #{log_file} 2>&1")

grep_exit_code = system("grep -q \"KIF TESTING FINISHED: 0 failures\" #{log_file}")

app_path = "/Users/Shared/Jenkins/Library/Application Support/iPhone Simulator/5.0/Applications/"
%x[ killall "iPhone Simulator" ]
system("rm -rf '#{app_path}'")

File.open(log_file, 'r') do |f1|
  while line = f1.gets
    puts line
  end
end

unless grep_exit_code
  exit 1
end
exit 0
