require "getoptlong"
require "extra/print_file.rb"

ACTION_BUILD = "build"
ACTION_CEDAR = "cedar"
ACTION_CALABASH = "calabash"

class Params
  # attributes
  attr_reader :action, :source_root, :target, :scheme, :workspace, :configuration,
    :architecture, :sdk, :family, :build_path, :log_file

  # public methods
  public

  def initialize
    set_defaults
    begin
      parse_action
      getoptlong = get_options
      parse_options(getoptlong)
      check_options
      set_log_file

    rescue StandardError=>error
      puts "\n#{error}\n#{usage}"
      exit 1
    end
  end

  def app_name
    target? ? @target : @scheme
  end

  def workspace?
    !@scheme.nil? && !@workspace.nil?
  end

  def target?
    !@target.nil?
  end

  # private methods
  private

  def set_defaults
    @architecture = "iphonesimulator"
    @configuration = "Release"
    @build_path = "build"
  end

  def parse_action
    @action = ARGV.shift
    raise unless check_action      
  end

  def get_options
    GetoptLong.new(
      [ '--target',  '-t', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--scheme',  '-h', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--workspace',  '-w', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--source-root', '-r', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--arch', '-a' ,GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--configuration', '-c', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--sdk',   '-s', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--log-file', '-l', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--family', '-f' ,GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--build-path', '-b' ,GetoptLong::OPTIONAL_ARGUMENT ]
    )
  end

  def parse_options(getoptlong)
    getoptlong.each do |opt, arg|
      case opt
        when ACTION_BUILD
          @action = ACTION_BUILD
        when ACTION_CEDAR
          @action = ACTION_CEDAR
        when ACTION_CALABASH
          @action = ACTION_CALABASH
        when "--source-root"
          @source_root = arg
        when "--target"
          @target = arg
        when "--scheme"
          @scheme = arg
        when "--workspace" 
          @workspace = arg
        when "--configuration"
          @configuration = arg
        when "--arch"
          @architecture = arg
        when "--sdk"
          @sdk = arg
        when "--family"
          @family = arg
        when "--build-path"
          @build_path = arg
        when "--log-file"
          @log_file = arg
      end
    end
	end

  def check_action
    @action == ACTION_BUILD || @action == ACTION_CEDAR || @action == ACTION_CALABASH
  end
  
  def check_options
    if self.action.nil?
      puts "You must specify action type"
      raise
    elsif self.source_root.nil?
      puts "You must specify source root"
      raise
    elsif !self.target? && !self.workspace?
      puts "You must specify target root or scheme and workspace"
      raise
    end
  end

  def set_log_file
    @log_file = "/tmp/#{@action}-#{app_name}-#{Time.now.to_i}.log" if @log_file.nil?
  end

  def usage
    print_file("lib/usage.txt")
  end
end
