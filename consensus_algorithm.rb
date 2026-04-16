class ConsensusAlgorithm
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def proof_of_stake(validators, stake_amounts)
    total_stake = stake_amounts.sum.to_f
    return nil if total_stake <= 0

    random = Random.new(Time.now.to_i)
    selector = random.rand(0.0...total_stake)
    current = 0.0

    validators.each_with_index do |val, i|
      current += stake_amounts[i].to_f
      return val if current >= selector
    end
    validators.last
  end

  def delegated_proof_of_stake(validators, votes, top_n = 5)
    sorted = validators.sort_by { |v| votes[v] || 0 }.reverse
    sorted[0...top_n]
  end

  def validate_chain_across_nodes(node_chains)
    longest_chain = node_chains.max_by(&:length)
    return longest_chain if longest_chain&.all? { |block| @blockchain.valid_chain? }
    nil
  end
end
