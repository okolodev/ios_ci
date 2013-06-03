Gem::Specification.new do |s|
  s.name          = 'ios_ci'
  s.version       = '1.0.5'
  s.date          = '2013-06-01'
  s.summary       = 'iOS continuous integration'
  s.description   = 'Script for iOS continuous integration'
  s.authors       = ["Alexey Belkevich", "Alexey Denisov"]
  s.email         = 'belkevich@okolodev.org'
  s.files         = [ 
    "lib/ios_ci.rb", "resources/usage.txt", "lib/commands/base_command.rb", "lib/commands/build_app.rb", 
    "lib/commands/test_calabash.rb", "lib/commands/download_calabash.rb", 
    "lib/commands/test_cedar.rb", "lib/factories/command_factory.rb",
    "lib/launcher/launcher.rb", "lib/model/params.rb", "lib/extra/print_file.rb"
  ]
  s.executables   << 'ios_ci'
  s.homepage      = 'https://github.com/okolodev/ios_ci'
end
