class Fidget::Platform
  require "dbus"

  def self.current_process(options)
    return false unless required_binaries
    options = munge(options)
    suspend(options)

    at_exit do
      resume(options)
    end
  end

  def self.prevent_sleep(options)
    return false unless required_binaries
    options = munge(options)
    suspend(options)

    if block_given?
      yield
      resume(options)
    end
  end

  def self.allow_sleep
    return false unless required_binaries
    options = munge(options)
    resume(options)
  end

  def self.simulate
    return false unless required_binaries('xset')
    system('xset reset')
  end

  def self.munge(options)
    options.flatten!
    options.compact!
    options = [:display] if options.empty?
    options = [:display, :blanking] if options == [:all]
    options.each do |opt|
      STDERR.puts "Fidget: option {opt} is not supported on Linux" unless [:display, :blanking].include? opt
    end
    options
  end
  private_class_method :munge

  def self.root_win
    ids = `xwininfo -root`.each_line.collect do |line|
      next unless line =~ /Window id: (0x\h+)/
      $1
    end.compact
    raise "Parsing xwininfo failed" unless ids.size == 1
    ids.first
  end
  private_class_method :root_win

  def self.suspend(options)
    if options.include? :display
      # I'm sure that if we tried, we could find yet another way to do this
      system("xdg-screensaver suspend #{root_win}")
      system('xset s off')
      system('xset s noblank')
      system('xset -dpms')

      # xdg-screensaver doesn't actually seem to work, but making DBus calls ourself does.
      # This is possibly because the inhibit expires when the dbus-session command terminates
      # I don't know if this will work in other distros though. Yay for consistency. *\o/*
      begin
        @@cookie = dbus_screensaver.Inhibit(root_win, 'Administratively disabled')
      rescue => e
        STDERR.puts 'Fidget: DBus action failed.'
        STDERR.puts e.message
        STDERR.puts e.backtrace.first
      end
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
      system('xset +dpms')
      system('xset s on')

      # if we have a cookie, we can trust that DBus works
      dbus_screensaver.Uninhibit(@@cookie) if @@cookie
    end

    if options.include? :blanking
      system("setterm -blank #{@@blanking} -powerdown #{@@blanking}")
    end
  end
  private_class_method :resume

  def self.dbus_screensaver
    session = DBus.session_bus
    service = session['org.freedesktop.ScreenSaver']
    object  = service['/ScreenSaver']
    object.introspect
    object['org.freedesktop.ScreenSaver']
  end
  private_class_method :dbus_screensaver

  def self.required_binaries(*list)
    list = ['xset', 'xdg-screensaver', 'xwininfo'] if list.empty?
    found = true
    list.each do |command|
      unless system("which #{command} > /dev/null 2>&1")
        found = false
        Fidget.debug "Fidget: required binary (#{command}) not found."
      end
    end
    found
  end
  private_class_method :required_binaries
end
