require "classes/params.rb"

class BuildTester

  def initialize(params)
    @params = params
  end

  def run
    build_command = self.build_command
    puts build_command
    @result = system(build_command)
    self.print_result
 end

  def build_command
    build = self.build_target
    "cd #{@params.source_root} && xcodebuild #{build} -sdk #{@params.architecture} -configuration #{@params.configuration} clean build CONFIGURATION_BUILD_DIR=#{self.clean_dir}"
  end

  def build_target
    @params.target? ? "-target '#{@params.target}'" : 
      "-scheme '#{@params.scheme}' -workspace '#{@params.workspace}'"
  end

  def clean_dir
    "#{@params.source_root}/#{@params.build_path}/#{@params.configuration}-#{@params.architecture}"
  end

  def print_result
    puts @result ? "Target build succeeded" : "Target build failed"
  end

  def success?
    @result
  end

end
