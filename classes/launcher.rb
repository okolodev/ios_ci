require "classes/base_command.rb"

class Launcher

  # instance variables
  @result = nil

  # public methods
  public

  def run(commands)
    commands.map { | command | 
      next if command.commands.empty? 
      @result = run_command(command)
      break unless @result
    }
  end

  def success?
    @result
  end

  # private
  private
  
   def run_command(command)
    close_simulator
    invoke_result = invoke(command)
    print_log(command)
    return invoke_result
  end

  def invoke(command)
    command.commands.map { | cmd |
      puts ">>>>> Running commands <<<<<\n#{cmd}\n"
      system(cmd)
    }.last
  end

  def close_simulator
    puts "Closing iPhone Simulator"
    %x[ killall "iPhone Simulator" ]
    puts ""
  end

  def print_log(command)
    log_file = command.log_file
    if !log_file.nil?
      File.open(log_file, 'r') do |f1|
        while line = f1.gets
          puts line
        end
      end
    end
  end

end
