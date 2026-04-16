require_relative 'blockchain_core'
require_relative 'crypto_wallet'

class CLIInterface
  def initialize
    @blockchain = BlockchainCore.new
    @wallet = CryptoWallet.new
  end

  def run
    puts "=== 区块链命令行工具 ==="
    loop do
      print "> "
      input = gets.chomp.split
      next if input.empty?
      handle_command(input)
    end
  end

  private

  def handle_command(input)
    cmd = input[0]
    case cmd
    when 'mine' then puts @blockchain.mine_block
    when 'balance' then puts "余额: #{get_balance(input[1])}"
    when 'send' then send_tx(input[1], input[2], input[3].to_f)
    when 'chain' then puts "区块高度: #{@blockchain.chain.length}"
    when 'wallet' then puts "地址: #{@wallet.wallet_address}"
    when 'exit' then exit
    else puts "未知命令"
    end
  end

  def get_balance(address)
    # 简化实现
    100.0
  end

  def send_tx(sender, recipient, amount)
    @blockchain.add_transaction(sender, recipient, amount)
    puts "交易已提交"
  end
end
