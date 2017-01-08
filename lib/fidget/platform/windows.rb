require 'Win32API'

class Fidget::Platform
  ES_CONTINUOUS        = 0x80000000
  ES_SYSTEM_REQUIRED   = 0x00000001
  ES_DISPLAY_REQUIRED  = 0x00000002
  ES_AWAYMODE_REQUIRED = 0x00000040

  KB_EVENT_KEYPRESS = 0
  KB_EVENT_KEYUP    = 2
  KB_KEY_F24        = 0x87

  def self.current_process(options)
    set_state(options)

    at_exit do
      set_state(nil)
    end
  end

  def self.prevent_sleep(options)
    set_state(options)

    if block_given?
      yield
      set_state(nil)
    end

    pid
  end

  def self.allow_sleep(handle)
    set_state(nil)
  end

  # Set thread execution state, using information from
  # https://msdn.microsoft.com/en-us/library/aa373208(VS.85).aspx
  # http://stackoverflow.com/questions/4126136/stop-a-windows-7-pc-from-going-to-sleep-while-a-ruby-program-executes
  def self.set_state(*options)
    options.flatten!
    options.compact!
    options = [:display, :sleep] if options.empty?
    options = [:display, :sleep, :away] if options == [:all]

    terms = {
      :display => ES_DISPLAY_REQUIRED,
      :sleep   => ES_SYSTEM_REQUIRED,
      :away    => ES_AWAYMODE_REQUIRED,
    }
    options.each do |opt|
      STDERR.puts "Fidget: option #{opt} is not supported on Windows" unless terms.include? opt
    end

    # translate options to constants, then OR them all together
    mode = options.map { |element| terms[element] }.reduce { |memo, element| memo|element } || 0

    state = Win32API.new('kernel32','SetThreadExecutionState','L')
    state.call(ES_CONTINUOUS|mode)

    if options.include? :display
      @@kb_poker = Thread.new do
        kb = Win32API.new('user32.dll', 'keybd_event', 'nnnn', 'v')
        loop do
          kb.call(KB_KEY_F24, 0, KB_EVENT_KEYPRESS, nil)
          kb.call(KB_KEY_F24, 0, KB_EVENT_KEYUP, nil)
          sleep 30
        end
      end
    end

    if options.nil?
      Thread.kill @@kb_poker if @@kb_poker
    end
  end
  private_class_method :set_state

end
