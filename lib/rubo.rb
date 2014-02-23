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

  # Loads every external gems of Rubo
  #
  # @return [void]
  def self.load_external_gems
    Gem.refresh
    Gem::Specification.each do |gem|
      if gem.name =~ /^rubo-/
        begin
          logger.debug "Loading gem \"#{gem.name}\""
          require gem.name
        rescue ::LoadError => e
          logger.warn \
            "Could not load gem \"#{gem.name}\": #{e.message}\n" +
            e.backtrace.join("\n")
        end
      end
    end
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
