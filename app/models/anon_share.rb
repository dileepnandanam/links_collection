require 'openssl'
class AnonShare < ActiveRecord::Base
  self.table_name = 'posts'
  attr_accessor :user_name

  def encrypt
    content = {
      text: text,
      title: title,
      user_name: user_name
    }.to_json

    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = Digest::SHA1.hexdigest KEY
    s = cipher.update(content) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def self.decrypt(encrypted_content)
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = Digest::SHA1.hexdigest KEY
    s = [encrypted_content].pack("H*").unpack("C*").pack("c*")

    decrypted = cipher.update(s) + cipher.final
    self.new(JSON.parse(decrypted))
  end

  KEY = '1AFCDE3EAA'
end