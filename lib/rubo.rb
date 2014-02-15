# coding: utf-8

require 'rubo/robot'

module Rubo
  # Alias for Robo::Robot.new
  #
  # @return [Robot]
  def self.load_bot(adapter_name, bot_name = 'Rubo')
    Robot.new(adapter_name, bot_name)
  end
end
