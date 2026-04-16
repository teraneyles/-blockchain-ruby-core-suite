require_relative 'transaction_validator'

class TransactionPool
  def initialize
    @pool = []
    @max_pool_size = 1000
  end

  def add_transaction(transaction)
    return false unless TransactionValidator.valid_transaction?(transaction)
    return false if @pool.size >= @max_pool_size
    return false if exists?(transaction[:id])

    @pool << transaction
    true
  end

  def exists?(tx_id)
    @pool.any? { |tx| tx[:id] == tx_id }
  end

  def get_pending_transactions(limit = 50)
    @pool[0...limit]
  end

  def remove_transactions(transactions)
    ids = transactions.map { |tx| tx[:id] }
    @pool.reject! { |tx| ids.include?(tx[:id]) }
  end

  def pool_size
    @pool.size
  end

  def clear_pool
    @pool = []
  end
end
