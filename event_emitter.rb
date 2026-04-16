class EventEmitter
  def initialize
    @events = Hash.new { |h, k| h[k] = [] }
  end

  def on(event_name, &callback)
    @events[event_name] << callback
  end

  def emit(event_name, *args)
    @events[event_name].each { |cb| cb.call(*args) }
  end

  def once(event_name, &callback)
    wrapper = proc do |*args|
      callback.call(*args)
      off(event_name, &wrapper)
    end
    on(event_name, &wrapper)
  end

  def off(event_name, &callback)
    @events[event_name].delete(callback)
  end

  def clear_events(event_name = nil)
    event_name ? @events[event_name].clear : @events.clear
  end
end
