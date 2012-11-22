require "classes/params.rb"

class CalabashTester
  
  def initialize(params)
    @params = params
    if @params.log_file.nil?
      @params.log_file =  "/tmp/calabash-#{self.app_name}-#{Time.now.to_i}.log"
    end
  end

  def run
    puts "Closing iPhone Simulator"
    %x[ killall "iPhone Simulator" ]
    app_path = self.app_path
    puts ""
    puts ">>>>>>>>> #{app_path} <<<<<<<<<"
    system("cd #{@params.source_root} && APP_BUNDLE_PATH='#{app_path}' #{self.test_command} -o #{@params.log_file} --require features")
    @result = system("grep -q \"failed\" #{@params.log_file}")
    self.print_log
    self.print_result
  end

  def test_command
    "cucumber"
  end

  def app_path
    "#{@params.source_root}/build/#{@params.configuration}-#{@params.architecture}/#{self.app_name}.app"
  end

  def app_name
    name = @params.target? ? @params.target : @params.scheme
 end

  def print_log
    File.open(@params.log_file, 'r') do |f1|
      while line = f1.gets
        puts line
      end
    end
  end

  def print_result
    puts @result ? "Calabash test failed" : "Calabash test succeeded" 
  end

  def success?
    @result
  end

end
