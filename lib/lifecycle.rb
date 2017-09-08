require "statesman"

require "lifecycle/version"

module Lifecycle
  def self.manager
    @mgr
  end

  def self.manage(app)
    @mgr = Manager.new(app)
    
    trap('TERM') do
      @mgr.shutdown
    end

    begin
      @mgr.startup
      @mgr.run
    rescue Exception => e
      raise e
    ensure
      @mgr.shutdown
    end
  end

  class Manager
    def initialize(app)
      @app = app
      @fsm ||= LifecycleStateMachine.new(self)
    end

    def app
      @app
    end

    # TODO: Fix rescue
    def startup
      begin
        state_machine.transition_to!(:startup)
        app.startup
      rescue Exception => exception
        raise exception
      end
    end

    # TODO: Fix rescue
    def run
      if state_machine.can_transition_to?(:running)
        begin
          state_machine.transition_to!(:running)
          app.run
        rescue Exception => exception
          raise exception
        end
      end
    end

    def shutdown
      if state_machine.can_transition_to?(:shutdown)
        begin
          state_machine.transition_to!(:shutdown)
          app.shutdown
        rescue Exception => exception
          raise exception
        end
      end
    end

    def state_machine
      @fsm
    end

    def current_state
      state_machine.current_state
    end
  end

  # Our state machine definition
  class LifecycleStateMachine
    include Statesman::Machine

    state :startup, initial: true
    state :running
    state :shutdown

    transition from: :startup, to: :startup
    transition from: :startup, to: :running
    transition from: :running, to: :shutdown
  end
end
