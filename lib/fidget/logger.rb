class Fidget
  require 'logger'

  def self.logger
    unless @logger
      @logger = Logger.new(STDERR)
      @logger.level = Logger::WARN
    end
    @logger
  end
  private_class_method :logger

  def self.error(message)
    logger.error(message)
  end

  def self.warn(message)
    logger.warn(message)
  end

  def self.debug(message)
    logger.debug(message)
  end

  def self.debuglevel=(level)
    logger.level = level
  end
end
