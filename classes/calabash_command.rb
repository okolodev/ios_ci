require "classes/base_command.rb"

class CalabashCommand < BaseCommand

  # overrides from base class 
  def before_command
  end

  def main_command
    "cd #{@params.source_root} && APP_BUNDLE_PATH='#{app_path}' #{test_command} -o #{log_file} --require features"
  end

  def after_command
    "! grep -q \"failed\" #{log_file} && grer -q \"passed\" #{log_file}"
  end

  # private methods
  private

  def test_command
    "cucumber"
  end

end
