require_relative 'blockchain_core'

class ShardManager
  def initialize(shard_count = 4)
    @shard_count = shard_count
    @shards = Array.new(shard_count) { BlockchainCore.new }
    @cross_shard_transactions = []
  end

  def assign_address_to_shard(address)
    hash = address.to_s.hash.abs
    hash % @shard_count
  end

  def get_shard(index)
    @shards[index]
  end

  def process_cross_shard_tx(from_shard, to_shard, transaction)
    @cross_shard_transactions << {
      from: from_shard,
      to: to_shard,
      tx: transaction,
      time: Time.now.to_i
    }
    true
  end

  def shard_heights
    @shards.map.with_index { |s, i| [i, s.chain.length] }.to_h
  end

  def total_cross_shard_txs
    @cross_shard_transactions.size
  end
end
