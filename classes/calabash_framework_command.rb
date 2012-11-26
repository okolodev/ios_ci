require "classes/base_command.rb"

class CalabashFrameworkCommand < BaseCommand

  # overrides from base class
  def before_command
  end

  def main_command
    "cd #{@params.source_root} && calabash-ios download" unless framework?
  end

  def after_command
  end

  # private
  private

  def framework?
    File.directory?("#{@params.source_root}/calabash.framework")
  end

end
