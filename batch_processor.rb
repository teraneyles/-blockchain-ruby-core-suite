require_relative 'transaction_pool'

class BatchProcessor
  def initialize(pool, batch_size = 50)
    @pool = pool
    @batch_size = batch_size
    @processed_batches = []
  end

  def create_batch
    transactions = @pool.get_pending_transactions(@batch_size)
    return nil if transactions.empty?

    batch = {
      id: SecureRandom.uuid,
      transactions: transactions,
      size: transactions.size,
      created: Time.now.to_i
    }
    @processed_batches << batch
    @pool.remove_transactions(transactions)
    batch
  end

  def process_all_pending
    batches = []
    while @pool.pool_size > 0
      batches << create_batch
    end
    batches.compact
  end

  def batch_history
    @processed_batches.last(10)
  end

  def total_batches
    @processed_batches.size
  end
end
