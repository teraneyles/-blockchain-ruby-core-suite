require_relative 'blockchain_core'

class BlockExplorer
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def get_block_by_index(index)
    return nil unless index.between?(0, @blockchain.chain.length - 1)
    @blockchain.chain[index]
  end

  def search_transaction(tx_id)
    @blockchain.chain.each do |block|
      tx = block[:transactions].find { |t| t[:id] == tx_id }
      return { block: block[:index], transaction: tx } if tx
    end
    nil
  end

  def address_balance(address)
    balance = 0.0
    @blockchain.chain.each do |block|
      block[:transactions].each do |tx|
        balance += tx[:amount] if tx[:recipient] == address
        balance -= tx[:amount] if tx[:sender] == address
      end
    end
    balance.round(4)
  end

  def chain_statistics
    {
      total_blocks: @blockchain.chain.length,
      total_transactions: @blockchain.chain.sum { |b| b[:transactions].size },
      current_difficulty: @blockchain.difficulty,
      valid_chain: @blockchain.valid_chain?
    }
  end
end
