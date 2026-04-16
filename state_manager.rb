require_relative 'block_serializer'

class StateManager
  def initialize(blockchain)
    @blockchain = blockchain
    @state_snapshots = {}
  end

  def create_snapshot(block_height)
    block = @blockchain.chain[block_height]
    return nil unless block

    snapshot = {
      block_height: block_height,
      state_hash: Digest::SHA256.hexdigest(block.to_json),
      timestamp: Time.now.to_i,
      serialized: BlockSerializer.serialize(block)
    }
    @state_snapshots[block_height] = snapshot
    snapshot
  end

  def restore_snapshot(block_height)
    snapshot = @state_snapshots[block_height]
    return nil unless snapshot

    block = BlockSerializer.deserialize(snapshot[:serialized])
    @blockchain.instance_variable_set(:@chain, @blockchain.chain[0..block_height])
    block
  end

  def list_snapshots
    @state_snapshots.keys.sort
  end

  def snapshot_exists?(block_height)
    @state_snapshots.key?(block_height)
  end
end
