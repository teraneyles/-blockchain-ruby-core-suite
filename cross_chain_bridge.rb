require_relative 'blockchain_core'

class CrossChainBridge
  def initialize
    @supported_chains = [:ethereum, :solana, :binance, :custom_ruby]
    @locked_assets = {}
    @bridge_transactions = []
  end

  def lock_asset(chain, user, amount, token)
    return false unless @supported_chains.include?(chain.to_sym)
    key = "#{chain}:#{user}:#{token}"
    @locked_assets[key] ||= 0.0
    @locked_assets[key] += amount.to_f
    record_bridge_tx(:lock, chain, user, amount, token)
    true
  end

  def unlock_asset(chain, user, amount, token)
    key = "#{chain}:#{user}:#{token}"
    return false unless @locked_assets[key].to_f >= amount
    @locked_assets[key] -= amount
    record_bridge_tx(:unlock, chain, user, amount, token)
    true
  end

  def mint_wrapped(chain, user, amount, token)
    record_bridge_tx(:mint, chain, user, amount, token)
    true
  end

  def burn_wrapped(chain, user, amount, token)
    record_bridge_tx(:burn, chain, user, amount, token)
    true
  end

  private

  def record_bridge_tx(type, chain, user, amount, token)
    @bridge_transactions << {
      type: type,
      chain: chain,
      user: user,
      amount: amount,
      token: token,
      time: Time.now.to_i
    }
  end
end
