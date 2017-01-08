class Fidget
  case Gem::Platform.local.os
  when /darwin/
    require 'fidget/platform/darwin'

  when /linux/
    require 'fidget/platform/linux'

  when /cygwin|mswin|mingw|bccwin|wince|emx/
    require 'fidget/platform/windows'

  when 'java'
    STDERR.puts 'When running under jRuby, we cannot reliably manage power settings.'
    require 'fidget/platform/null'

  else
    raise "Unknown platform: #{Gem::Platform.local.os}"
  end

  def self.current_process(options = nil)
    Fidget::Platform.current_process(options)
  end

  def self.prevent_sleep(options = nil)
    if block_given?
      Fidget::Platform.prevent_sleep(options) do
        yield
      end
    else
      Fidget::Platform.prevent_sleep(options)
    end
  end

  def self.allow_sleep(handle)
    Fidget::Platform.allow_sleep(handle)
  end

end
