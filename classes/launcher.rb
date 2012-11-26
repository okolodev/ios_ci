require "classes/base_command.rb"

class Launcher

  # instance variables
  @result = nil
  @command = nil

  # public methods
  public

  def run(command)
    @command = command
    close_simulator
    invoke
    print_log
  end

  def success?
    @result
  end

  # private
  private
  
  def invoke
    @result = @command.commands.map { | cmd |
      puts ">>>>> Running commands <<<<<\n#{cmd}\n"
      system(cmd)
    }.last
  end

  def close_simulator
    puts "Closing iPhone Simulator"
    %x[ killall "iPhone Simulator" ]
    puts ""
  end

  def print_log
    log_file = @command.log_file
    if !log_file.nil?
      File.open(log_file, 'r') do |f1|
        while line = f1.gets
          puts line
        end
      end
    end
  end

end
