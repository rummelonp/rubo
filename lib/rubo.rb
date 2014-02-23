# coding: utf-8

require 'logger'
require 'rubo/robot'

module Rubo
  # Alias for Robo::Robot.new
  #
  # @return [Robot]
  def self.load_bot(adapter_name, bot_name = 'Rubo')
    Robot.new(adapter_name, bot_name)
  end

  # Returns a shared logger of Rubo
  #
  # @return [Logger]
  def self.logger
    @logger ||= (
      begin
        logger = Logger.new($stdout)
        level = (ENV['RUBO_LOG_LEVEL'] || 'info').upcase
        logger.level = Logger.const_get(level)
        logger
      end
    )
  end

  # Set a new logger
  #
  # @param [Logger]
  # @return [void]
  def self.logger=(logger)
    @logger = logger
  end
end
