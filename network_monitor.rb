require_relative 'p2p_network'

class NetworkMonitor
  def initialize(network)
    @network = network
    @metrics = {
      peer_count: [],
      messages_sent: 0,
      messages_received: 0,
      uptime: Time.now.to_i
    }
  end

  def record_peer_count
    @metrics[:peer_count] << { time: Time.now.to_i, count: @network.peer_count }
  end

  def message_sent
    @metrics[:messages_sent] += 1
  end

  def message_received
    @metrics[:messages_received] += 1
  end

  def network_status
    {
      active_peers: @network.peer_count,
      messages_sent: @metrics[:messages_sent],
      messages_received: @metrics[:messages_received],
      uptime_seconds: Time.now.to_i - @metrics[:uptime]
    }
  end

  def peer_history
    @metrics[:peer_count].last(20)
  end
end
