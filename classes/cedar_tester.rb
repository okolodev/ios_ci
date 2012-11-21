require "classes/params.rb"

SIM_PATH = "/usr/local/bin/ios-sim"

class CedarTester

  def initialize(params)
    @params = params
    if @params.log_file.nil?
      @params.log_file = "/tmp/cedar-#{self.app_name}-#{Time.now.to_i}.log"
    end
  end

  def run
    puts "Closing iPhone Simulator"
    %x[ killall "iPhone Simulator" ]
    puts ""
    puts ">>>>>>>>> #{app_path} <<<<<<<<<"
    puts "#{self.test_command} > #{@params.log_file} 2>&1"
    system("#{self.test_command} > #{@params.log_file} 2>&1")
    @result = system("grep -q \"0 failures\" #{@params.log_file}")
    self.print_log
    self.print_result
  end

  def test_command 
    command = "#{SIM_PATH} launch #{self.app_path} --setenv CEDAR_HEADLESS_SPECS=1\
 --setenv CEDAR_REPORTER_CLASS=CDRColorizedReporter,CDRJUnitXMLReporter\
 --setenv CEDAR_JUNIT_XML_FILE=#{@params.source_root}/test-reports/cedar.xml"
    command += " --family #{@params.family} " unless @params.family.nil?
    command += " --sdk #{@params.sdk} " unless @params.sdk.nil?
    command
  end

  def app_path
    "#{@params.source_root}/#{@params.build_path}/#{@params.configuration}-#{@params.architecture}/#{self.app_name}.app"
  end

  def app_name
    @params.target? ? @params.target : @params.scheme
  end

  def print_log
    File.open(@params.log_file, 'r') do |f1|
      while line = f1.gets
        puts line
      end
    end
  end

  def print_result
    puts @result ? "Cedar test succeeded" :  "Cedar tests failed"
  end

  def success?
    @result
  end

end
