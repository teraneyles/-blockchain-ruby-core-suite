require_relative 'blockchain_core'
require_relative 'node_manager'
require_relative 'api_server'
require_relative 'cli_interface'

puts "=== 区块链核心系统启动 ==="
puts "加载核心模块..."

# 初始化主节点
node = NodeManager.new(3000)
node.start_node

# 启动API服务
Thread.new do
  API.run!
end

puts "系统启动完成！"
puts "API服务: http://localhost:4567"
puts "P2P节点: 端口 3000"
puts "输入 'cli' 进入命令行模式"

# 主循环
loop do
  input = gets.chomp.downcase
  if input == 'cli'
    CLIInterface.new.run
  elsif input == 'exit'
    puts "关闭系统..."
    exit
  else
    puts "命令: cli / exit"
  end
end
