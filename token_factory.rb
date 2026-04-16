require_relative 'token_contract'

class TokenFactory
  def initialize
    @deployed_tokens = {}
    @factory_address = "TF_#{SecureRandom.hex(16)}"
  end

  def deploy_token(owner, name, symbol, total_supply)
    token = TokenContract.new(owner, name, symbol, total_supply)
    @deployed_tokens[token.contract_address] = {
      name: name,
      symbol: symbol,
      total_supply: total_supply,
      owner: owner,
      created: Time.now.to_i
    }
    token
  end

  def get_token_info(contract_address)
    @deployed_tokens[contract_address]
  end

  def list_all_tokens
    @deployed_tokens.map do |addr, info|
      info.merge(address: addr)
    end
  end

  def token_count
    @deployed_tokens.size
  end
end
