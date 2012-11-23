require "getoptlong"

class Params
	attr_accessor :source_root, :target, :scheme, :workspace, :configuration, :architecture,
					:sdk, :family, :build_path, :log_file

	def initialize(usage)
    self.set_defaults
    begin
      getoptlong = self.get_options
      self.parse_options(getoptlong)
      self.check_options

    rescue StandardError=>error
      puts "\n#{error}\n#{usage}"
      exit 1
    end
  end

  def set_defaults
    self.architecture = "iphonesimulator"
    self.configuration = "Release"
    self.build_path = "build"
  end

  def get_options
    GetoptLong.new(
      [ '--sdk',   '-s', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--target',  '-t', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--scheme',  '-h', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--workspace',  '-w', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--configuration', '-c', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--log-file', '-l', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--source-root', '-r', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--arch', '-a' ,GetoptLong::REQUIRED_ARGUMENT ],
      [ '--family', '-f' ,GetoptLong::REQUIRED_ARGUMENT ],
      [ '--build-path', '-b' ,GetoptLong::REQUIRED_ARGUMENT ]
    )
  end

  def parse_options(getoptlong)
    getoptlong.each do |opt, arg|
      case opt
        when "--source-root"
          self.source_root = arg
        when "--target"
          self.target = arg
        when "--scheme"
          self.scheme = arg
        when "--workspace" 
          self.workspace = arg
        when "--configuration"
          self.configuration = arg
        when "--arch"
          self.architecture = arg
        when "--sdk"
          self.sdk = arg
        when "--family"
          self.family = arg
        when "--build-path"
          self.build_path = arg
        when "--log-file"
          self.log_file = arg
      end
    end
	end

  def check_options
    if self.source_root.nil?
      puts "You must specify source root"
      raise
    elsif !self.target? && !self.workspace?
      puts "You must specify target root or scheme and workspace"
      raise
    end
  end

  def workspace?
    !scheme.nil? && !workspace.nil?
  end

  def target?
    !target.nil?
  end

end
