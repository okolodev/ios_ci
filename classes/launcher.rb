require "classes/base_command.rb"
require "classes/print_file.rb"

class Launcher

  # instance variables
  @result = nil

  # public methods
  public

  def run(commands)
    commands.map { | command | 
      next if command.empty? 
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
    invoke_result = invoke(command.all_commands)
    print_file(command.log_file) unless command.log_file.nil?
    return invoke_result
  end

  def invoke(commands)
    commands.map { | cmd |
      puts ">>>>> Running commands <<<<<\n#{cmd}\n"
      system(cmd)
    }.last
  end

  def close_simulator
    puts "Closing iPhone Simulator"
    %x[ killall "iPhone Simulator" ]
    puts ""
  end

end
