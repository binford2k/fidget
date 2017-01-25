class Fidget::Platform
  def self.current_process(options)
    false
  end

  def self.prevent_sleep(options)
    return false

    # prevent sleep
    if block_given?
      yield
      # allow sleep
    end
  end

  def self.allow_sleep
    false
  end

  def self.simulate
    false
  end

end
