Gem::Specification.new do |s|
  s.name          = 'ios_ci'
  s.version       = '1.0.0'
  s.date          = '2012-11-28'
  s.summary       = 'iOS continuous integration'
  s.description   = 'Script for iOS continuous integration'
  s.authors       = ["Alexey Belkevich", "Alexey Denisov"]
  s.email         = 'belkevich@okolodev.org'
  s.files         = [ 
    "usage.txt", "lib/base_command.rb", "lib/build_command.rb", "lib/calabash_command.rb", 
    "lib/calabash_framework_command.rb", "lib/cedar_command.rb", "lib/command_factory.rb",
    "lib/launcher.rb", "lib/params.rb", "lib/print_file.rb"
  ]
  s.executables   << 'ios_ci'
  s.homepage      = 'https://github.com/okolodev/ios_ci'
end
