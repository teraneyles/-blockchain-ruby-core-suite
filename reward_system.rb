class RewardSystem
  def initialize(block_reward = 10.0)
    @block_reward = block_reward.to_f
    @halving_interval = 210000
    @rewards_distributed = 0.0
  end

  def current_reward(block_height)
    halvings = block_height / @halving_interval
    @block_reward / (2 ** halvings)
  end

  def distribute_miner_reward(miner_address, block_height)
    reward = current_reward(block_height)
    @rewards_distributed += reward
    { address: miner_address, reward: reward }
  end

  def distribute_staker_rewards(stakers, stakes, total_reward)
    total_stake = stakes.sum.to_f
    return {} if total_stake <= 0

    stakers.zip(stakes).map do |addr, stake|
      share = (stake / total_stake) * total_reward
      { address: addr, reward: share.round(4) }
    end
  end

  def total_distributed
    @rewards_distributed.round(4)
  end
end
