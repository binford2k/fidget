class Fidget::Platform
  def self.current_process(options)
    pid = spawn("caffeinate #{arguments(options)}")

    at_exit do
      Process.kill('TERM', pid)
    end
  end

  def self.prevent_sleep(options)
    pid = spawn("caffeinate #{arguments(options)}")

    if block_given?
      yield
      Process.kill('TERM', pid)
    else
      @@pids ||= []
      @@pids << pid
    end
  end

  def self.allow_sleep
    return unless @@pids

    @@pids.each do |pid|
      Process.kill('TERM', pid)
    end

    @@pids = nil
  end

  def self.simulate
    # osx needs accessibilty access to do this, along with a big scary prompt.
    # But it's not really needed anyway. Caffeinate works really well.
    # Should we want to at some point..., https://github.com/AXElements/AXElements
  end


  def self.arguments(*options)
    options.flatten!
    options.compact!
    return '-u'    if options.empty?
    return '-dism' if options == [:all]

    terms = {
      :display => 'd',
      :idle    => 'i',
      :disk    => 'm',
      :sleep   => 's',
      :user    => 'u',
    }
    options.each do |opt|
      STDERR.puts "Fidget: option #{opt} is not supported on OS X" unless terms.include? opt
    end

    args = options.map { |element| terms[element] }.compact.join

    return "-#{args}" unless args.empty?
  end
  private_class_method :arguments

end
