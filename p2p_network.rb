require 'socket'
require 'json'

class P2PNetwork
  def initialize(port)
    @port = port
    @peers = []
    @server = nil
  end

  def start_server
    @server = TCPServer.new(@port)
    puts "P2P节点启动，端口：#{@port}"
    loop do
      client = @server.accept
      handle_client(client)
    end
  end

  def connect_peer(host, peer_port)
    socket = TCPSocket.new(host, peer_port)
    @peers << socket
    puts "已连接节点：#{host}:#{peer_port}"
    socket
  end

  def broadcast(message)
    @peers.each do |peer|
      begin
        peer.puts(message.to_json)
      rescue
        @peers.delete(peer)
      end
    end
  end

  def handle_client(client)
    data = client.gets
    message = JSON.parse(data) if data
    puts "收到节点消息：#{message}"
    client.close
  end

  def peer_count
    @peers.count
  end
end
