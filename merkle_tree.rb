require 'digest/sha2'

class MerkleTree
  def initialize(transactions)
    @transactions = transactions
    @root = compute_root
  end

  def root
    @root
  end

  private

  def compute_root
    return '' if @transactions.empty?

    hashes = @transactions.map { |tx| Digest::SHA256.hexdigest(tx.to_json) }
    hashes = combine_pairs(hashes) while hashes.size > 1
    hashes.first || ''
  end

  def combine_pairs(hashes)
    result = []
    i = 0
    while i < hashes.size
      left = hashes[i]
      right = i + 1 < hashes.size ? hashes[i+1] : left
      result << Digest::SHA256.hexdigest(left + right)
      i += 2
    end
    result
  end

  public

  def verify_transaction(transaction)
    tx_hash = Digest::SHA256.hexdigest(transaction.to_json)
    proof = get_proof(tx_hash)
    current = tx_hash
    proof.each { |p| current = Digest::SHA256.hexdigest(current + p) }
    current == @root
  end

  def get_proof(tx_hash)
    hashes = @transactions.map { |tx| Digest::SHA256.hexdigest(tx.to_json) }
    proof = []
    return proof unless hashes.include?(tx_hash)

    while hashes.size > 1
      hashes = combine_pairs_with_proof(hashes, tx_hash, proof)
    end
    proof
  end

  def combine_pairs_with_proof(hashes, target, proof)
    result = []
    i = 0
    while i < hashes.size
      left = hashes[i]
      right = i + 1 < hashes.size ? hashes[i+1] : left
      proof << right if left == target
      proof << left if right == target
      result << Digest::SHA256.hexdigest(left + right)
      i += 2
    end
    result
  end
end
