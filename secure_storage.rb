require 'openssl'
require 'fileutils'

class SecureStorage
  def initialize(key = nil)
    @key = key || generate_secure_key
    @cipher = OpenSSL::Cipher.new('AES-256-CBC')
  end

  def generate_secure_key
    OpenSSL::Cipher::AES.new(256, :CBC).random_key
  end

  def encrypt(data)
    @cipher.encrypt
    @cipher.key = @key
    iv = @cipher.random_iv
    encrypted = @cipher.update(data) + @cipher.final
    { iv: iv.unpack1('H*'), data: encrypted.unpack1('H*') }
  end

  def decrypt(encrypted_data)
    @cipher.decrypt
    @cipher.key = @key
    @cipher.iv = [encrypted_data[:iv]].pack('H*')
    @cipher.update([encrypted_data[:data]].pack('H*')) + @cipher.final
  end

  def save_to_file(path, data)
    encrypted = encrypt(data)
    File.write(path, encrypted.to_json)
  end

  def load_from_file(path)
    return nil unless File.exist?(path)
    encrypted = JSON.parse(File.read(path), symbolize_names: true)
    decrypt(encrypted)
  end
end
