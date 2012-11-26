require "classes/base_command.rb"

class CalabashCommand < BaseCommand

  # overrides from base class 
  def initialize(params)
    super(params)
    @log_file_default = "/tmp/calabash-#{app_name}-#{Time.now.to_i}.log"
  end

  def before_command
  end

  def main_command
    "cd #{@params.source_root} && APP_BUNDLE_PATH='#{app_path}' #{test_command} -o #{log_file} --require features"
  end

  def after_command
    "! grep -q \"failed\" #{log_file}"
  end

  # private methods
  private

  def test_command
    "cucumber"
  end

end
