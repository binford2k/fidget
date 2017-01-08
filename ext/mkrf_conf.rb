require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'

begin
  Gem::Command.build_args = ARGV
  rescue NoMethodError
end

inst = Gem::DependencyInstaller.new
begin
  if Gem::Platform.local.os == 'linux'
    inst.install 'ruby-dbus'
  end
rescue => e
  puts 'Dependency installation failed.'
  puts e.message
  exit(1)
end

# mkmf expects a Rakefile to exist
f = File.open(File.join(File.dirname(__FILE__), 'Rakefile'), 'w')
f.write("task :default\n")
f.close
