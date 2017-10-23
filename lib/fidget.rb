class Fidget
  require 'fidget/version'
  require 'fidget/logger'

  case Gem::Platform.local.os
  when /darwin/
    require 'fidget/platform/darwin'

  when /freebsd|linux/
    require 'fidget/platform/posix'

  when /cygwin|mswin|mingw|bccwin|wince|emx/
    require 'fidget/platform/windows'

  when 'java'
    logger.error 'When running under jRuby, we cannot reliably manage power settings.'
    require 'fidget/platform/null'

  else
    raise "Unknown platform: #{Gem::Platform.local.os}"
  end

  def self.current_process(*options)
    simulator(options)
    options.delete :simulate

    Fidget::Platform.current_process(options)
  end

  def self.prevent_sleep(*options)
    simulator(options)
    options.delete :simulate

    if block_given?
      Fidget::Platform.prevent_sleep(options) do
        yield
      end
    else
      Fidget::Platform.prevent_sleep(options)
    end

  end

  def self.allow_sleep
    Thread.kill @@simulator if @@simulator
    Fidget::Platform.allow_sleep
  end

  def self.simulator(options)
    # if :all or :simulate were passed, start up the action simulator
    unless (options & [:all, :simulate]).empty?
      @@simulator = Thread.new do
        loop do
          Fidget::Platform.simulate
          sleep 30
        end
      end

      # if this is still running, make sure it gets cleaned up
      at_exit do
        return unless @@simulator
        return unless @@simulator.alive?
        Thread.kill @@simulator
      end
    end

  end
  private_class_method :simulator

end
