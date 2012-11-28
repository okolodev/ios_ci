require "model/params.rb"
require "launcher/launcher.rb"
require "factories/command_factory.rb"

class IOSCI
  # instance variables
  @launcher = nil
  @params = nil

  # public methods
  public

  def initialize
    @launcher = Launcher.new
    @params = Params.new
    factory = CommandFactory.new(@params)
    run(factory.get_commands)
  end

  # private methods
  private

  def run(commands)
    @launcher.run(commands)
    if @launcher.success?
      puts "#{@params.action} succeeded"
      exit 0
    else
      puts "#{@params.action} failed"
      exit 1
    end
  end

end
