$:.unshift File.expand_path("../lib", __FILE__)
require 'fidget/version'
require 'date'

Gem::Specification.new do |s|
  s.name              = "fidget"
  s.version           = Fidget::VERSION
  s.date              = Date.today.to_s
  s.summary           = "Cross platform tool to prevent your computer from sleeping."
  s.homepage          = "https://github.com/binford2k/fidget"
  s.license           = 'Apache 2.0'
  s.email             = "binford2k@gmail.com"
  s.authors           = ["Ben Ford"]
  s.has_rdoc          = false
  s.require_path      = "lib"
  s.executables       = %w( fidget )
  s.files             = %w( README.md LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")

  s.add_dependency    "ruby-dbus"

  s.description       = <<-desc
  Fidget was inspired by the OS X commandline `caffeinate` tool, which in turn
  was inspired by the Caffeine menubar tool. However, this tool is cross platform
  and can be used as a Ruby library.

  This will work on:
    * Modern OS X
    * Linux with xdg-screensaver (Xorg)
    * Windows
  desc

end
