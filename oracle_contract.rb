require_relative 'smart_contract_base'

class OracleContract < SmartContractBase
  def initialize(owner)
    super(owner)
    @data_feeds = {}
    @oracle_nodes = []
  end

  def register_oracle(node_address)
    only_owner do
      @oracle_nodes << node_address unless @oracle_nodes.include?(node_address)
    end
  end

  def submit_data(oracle, key, value, timestamp)
    return false unless @oracle_nodes.include?(oracle)
    @data_feeds[key] = {
      value: value,
      timestamp: timestamp,
      provider: oracle
    }
    true
  end

  def get_data(key)
    @data_feeds.dig(key, :value)
  end

  def data_timestamp(key)
    @data_feeds.dig(key, :timestamp)
  end

  def active_oracles
    @oracle_nodes.size
  end
end
