
module Rubo
  # @abstract
  module Pluggable
    # Raw method for load plugin
    #
    # @abstract
    # @param robot [Robot]
    # @return [void]
    def call(robot)
    end
  end
end
