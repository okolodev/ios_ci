require "commands/base_command.rb"

class BuildApp < BaseCommand

  # overriding base class methods
  def before_command
    "cd #{@params.source_root} && pod install" if cocoapods?
  end

  def main_command
     "cd #{@params.source_root} && xcodebuild #{build_args} -sdk #{@params.architecture} -configuration #{@params.configuration} clean build"
  end

  def after_command
  end

  def log_file
  end

  # private methods
  private

  def build_args
    @params.target? ? "-target '#{@params.target}'" : 
      "-scheme '#{@params.scheme}' -workspace '#{@params.workspace}'"
  end

  def cocoapods?
    File.exist?("#{@params.source_root}/Podfile")
  end

end
