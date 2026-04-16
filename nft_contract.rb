require_relative 'smart_contract_base'

class NFTContract < SmartContractBase
  def initialize(owner, name, symbol)
    super(owner)
    @name = name
    @symbol = symbol
    @tokens = {}
    @owners = {}
    @token_counter = 0
  end

  def mint(to, metadata_uri)
    only_owner do
      token_id = @token_counter += 1
      @tokens[token_id] = {
        owner: to,
        metadata: metadata_uri,
        created_at: Time.now.to_i
      }
      @owners[to] ||= []
      @owners[to] << token_id
      token_id
    end
  end

  def transfer(from, to, token_id)
    return false unless @tokens.dig(token_id, :owner) == from
    @owners[from].delete(token_id)
    @owners[to] ||= []
    @owners[to] << token_id
    @tokens[token_id][:owner] = to
    true
  end

  def owner_of(token_id)
    @tokens.dig(token_id, :owner)
  end

  def token_metadata(token_id)
    @tokens.dig(token_id, :metadata)
  end

  def balance_of(owner)
    @owners[owner]&.size || 0
  end
end
