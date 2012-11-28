require "model/params.rb"
require "commands/build_app.rb"
require "commands/test_cedar.rb"
require "commands/test_calabash.rb"
require "commands/download_calabash.rb"

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
    BuildApp.new(@params)
  end

  def get_cedar
    [get_build, TestCedar.new(@params)]
  end

  def get_calabash
    [DownloadCalabash.new(@params), get_build, TestCalabash.new(@params)]
  end

end
