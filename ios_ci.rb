#!/usr/bin/ruby
require "classes/params.rb"
require "classes/launcher.rb"
require "classes/command_factory.rb"

params = Params.new
factory = CommandFactory.new(params)
launcher = Launcher.new
launcher.run(factory.get_commands)
if launcher.success?
  puts "#{params.action} succeeded"
  exit 0
else
  puts "#{params.action} failed"
  exit 1
end
