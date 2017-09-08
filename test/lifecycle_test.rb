require "test_helper"

class LifecycleTest < Minitest::Test
  def setup
    @app = TestApp.new
    @mgr = ::Lifecycle::Manager.new(@app)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Lifecycle::VERSION
  end

  def test_that_a_manager_is_created
    ::Lifecycle.manage(@app)
    assert_equal ::Lifecycle.manager.class, ::Lifecycle::Manager
  end

  def test_initial_state
    assert_equal @mgr.current_state, "startup"
  end

  def test_transition_to_running
    @mgr.run
    assert_equal @mgr.current_state, "running"
    assert_equal @app.state, "running"
  end

  def test_transition_to_shutdown
    @mgr.run
    @mgr.shutdown
    assert_equal @mgr.current_state, "shutdown"
    assert_equal @app.state, "shutdown"
  end

  def test_state_history
    @mgr.run
    @mgr.shutdown
    assert_equal @mgr.state_machine.history.length, 2
  end
end
