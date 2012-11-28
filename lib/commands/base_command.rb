require "model/params.rb"

class BaseCommand

  # public methods
  public

  def initialize(params)
    @params = params
  end
  
  def all_commands
    [before_command, main_command, after_command].compact
  end

  def empty?
    all_commands.empty?
  end

  def log_file
    @params.log_file
  end

  # override in subclasses
  def before_command
    raise "Invoking of abstract method 'before_command' of 'BaseCommand class'"
  end

  def main_command
    raise "Invoking of abstract method 'main_command' of 'BaseCommand class'"
  end

  def after_command
    raise "Invoking of abstract method 'after_command' of 'BaseCommand class'"
  end

  # private methods
  private

  def app_path
    "#{@params.source_root}/#{@params.build_path}/#{@params.configuration}-#{@params.architecture}/#{@params.app_name}.app"
  end

end
