require "classes/base_command.rb"

class Launcher

  # instance variables
  @result = nil

  # public methods
  public

  def run(commands, params)
    commands.map { | command_class | 
      command = command_class.new(params)
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
    print_log(command.log_file) unless command.log_file.nil?
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

  def print_log(log_file)
    File.open(log_file, 'r') do | f |
      while line = f.gets
        puts line
      end
    end
  end

end
