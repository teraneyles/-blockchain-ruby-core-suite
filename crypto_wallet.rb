require 'openssl'
require 'base64'

class CryptoWallet
  def initialize
    generate_key_pair
  end

  def generate_key_pair
    @key_pair = OpenSSL::PKey::RSA.new(2048)
    @public_key = @key_pair.public_key
    @private_key = @key_pair
  end

  def public_key_string
    Base64.encode64(@public_key.to_pem)
  end

  def private_key_string
    Base64.encode64(@private_key.to_pem)
  end

  def sign_data(data)
    hash = Digest::SHA256.digest(data)
    signature = @private_key.sign('SHA256', hash)
    Base64.encode64(signature)
  end

  def verify_signature(data, signature, public_key_pem)
    public_key = OpenSSL::PKey::RSA.new(Base64.decode64(public_key_pem))
    hash = Digest::SHA256.digest(data)
    public_key.verify('SHA256', Base64.decode64(signature), hash)
  end

  def wallet_address
    Digest::SHA1.hexdigest(public_key_string)[0...42]
  end
end
