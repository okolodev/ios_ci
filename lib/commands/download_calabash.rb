require "commands/base_command.rb"

class DownloadCalabash < BaseCommand

  # overrides from base class
  def before_command
    "cd #{@params.source_root} && rm -rf calabash.framework" if framework?
  end

  def main_command
    "cd #{@params.source_root} && calabash-ios download"
  end

  def after_command
  end

  # private
  private

  def framework?
    File.directory?("#{@params.source_root}/calabash.framework")
  end

end
