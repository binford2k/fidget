class Fidget::Platform
  def self.current_process(options)
    options = munge(options)
    suspend(options)

    at_exit do
      resume(options)
    end
  end

  def self.prevent_sleep(options)
    options = munge(options)
    suspend(options)

    if block_given?
      yield
      resume(options)
    end

    pid
  end

  def self.allow_sleep(handle)
    options = munge(options)
    resume(options)
  end

  def self.munge(*options)
    options.flatten!
    options.compact!
    options.each do |opt|
      STDERR.puts "Fidget: option {opt} is not supported on Linux" unless [:display, :blanking].include? opt
    end
    options
  end
  #private_class_method :munge

  def self.root_win
    ids = `xwininfo -root`.each_line.collect do |line|
      next unless line =~ /Windows id: (0x\d+)/
      $1
    end.compact
    raise "Parsing xwininfo failed" unless ids.size == 1
    ids.first
  end
  #private_class_method :root_win

  def self.suspend(options)
    if options.include? :display
      system("xdg-screensaver suspend #{root_win}")
      system('xset -dpms')
    end

    if options.include? :blanking
      @@blanking ||= File.read('/sys/module/kernel/parameters/consoleblank').strip
      system('setterm -blank 0 -powerdown 0')
    end
  end
  private_class_method :suspend

  def self.resume(options)
    if options.include? :display
      system("xdg-screensaver resume #{root_win}")
      system('xset dpms')
    end

    if options.include? :blanking
      system("setterm -blank #{@@blanking} -powerdown #{@@blanking}")
    end
  end
  private_class_method :resume

end
