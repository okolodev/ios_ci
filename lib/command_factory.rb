require "lib/params.rb"
require "lib/build_command.rb"
require "lib/cedar_command.rb"
require "lib/calabash_command.rb"
require "lib/calabash_framework_command.rb"

class CommandFactory
  # instance variables
  @params = nil

  # public methods
  public

  def initialize(params)
    @params = params
  end

  def get_commands
    if @params.action == ACTION_BUILD
      [get_build]
    elsif @params.action == ACTION_CEDAR
      get_cedar
    elsif @params.action == ACTION_CALABASH
      get_calabash
    end
  end

  #private methods
  private

  def get_build
    BuildCommand.new(@params)
  end

  def get_cedar
    [get_build, CedarCommand.new(@params)]
  end

  def get_calabash
    [CalabashFrameworkCommand.new(@params), get_build, CalabashCommand.new(@params)]
  end

end
