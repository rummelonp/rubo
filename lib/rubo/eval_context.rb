
module Rubo
  # @private
  class EvalContext
    attr_reader :robot

    def initialize(robot)
      @robot = robot
    end

    def evaluate(f)
      eval(File.read(f), binding)
    end
  end
end
