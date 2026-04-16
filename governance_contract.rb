require_relative 'smart_contract_base'

class GovernanceContract < SmartContractBase
  def initialize(owner)
    super(owner)
    @proposals = {}
    @votes = {}
    @proposal_id = 0
  end

  def create_proposal(creator, title, description, options)
    id = @proposal_id += 1
    @proposals[id] = {
      title: title,
      description: description,
      options: options,
      creator: creator,
      created: Time.now.to_i,
      active: true
    }
    id
  end

  def vote(voter, proposal_id, option)
    return false unless @proposals.dig(proposal_id, :active)
    return false if @votes.dig(proposal_id, voter)

    @votes[proposal_id] ||= {}
    @votes[proposal_id][voter] = option
    true
  end

  def close_proposal(proposal_id)
    only_owner do
      @proposals[proposal_id][:active] = false if @proposals[proposal_id]
    end
  end

  def proposal_results(proposal_id)
    return nil unless @proposals[proposal_id]
    votes = @votes[proposal_id] || {}
    tally = Hash.new(0)
    votes.each_value { |opt| tally[opt] += 1 }
    tally
  end
end
