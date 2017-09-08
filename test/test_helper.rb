$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "lifecycle"

require "minitest/autorun"

class TestApp
  attr_reader :state

  def initialize
    @state = "new"
  end

  def startup
    @state = "startup"
  end

  def run
    @state = "running"
  end

  def shutdown
    @state = "shutdown"
  end
end