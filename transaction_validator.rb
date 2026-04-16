require 'digest'

class TransactionValidator
  def self.valid_transaction?(transaction)
    required_fields = [:id, :sender, :recipient, :amount, :timestamp]
    return false unless required_fields.all? { |f| transaction.key?(f) }
    return false if transaction[:amount].to_f <= 0
    return false if transaction[:sender] == transaction[:recipient]
    return false unless valid_timestamp?(transaction[:timestamp])
    true
  end

  def self.valid_batch_transactions?(transactions)
    transactions.all? { |tx| valid_transaction?(tx) }
  end

  def self.transaction_hash(transaction)
    Digest::SHA256.hexdigest(transaction.to_json)
  end

  def self.valid_address?(address)
    address.is_a?(String) && address.length >= 26 && address.length <= 42
  end

  private

  def self.valid_timestamp?(timestamp)
    timestamp.is_a?(Integer) && timestamp > 0 && timestamp <= Time.now.to_i + 300
  end
end
