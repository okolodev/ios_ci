require "classes/base_command.rb"

class BuildCommand < BaseCommand

  # overriding base class methods
  def main_command
     "cd #{@params.source_root} && xcodebuild #{build_args} -sdk #{@params.architecture} -configuration #{@params.configuration} clean build CONFIGURATION_BUILD_DIR=#{clean_dir}"
  end

  def grep_command
    nil
  end

  # private methods
  private

  def build_args
    @params.target? ? "-target '#{@params.target}'" : 
      "-scheme '#{@params.scheme}' -workspace '#{@params.workspace}'"
  end

  def clean_dir
    "#{@params.source_root}/#{@params.build_path}/#{@params.configuration}-#{@params.architecture}"
  end

end
