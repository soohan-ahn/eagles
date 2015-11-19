require "bcrypt"

class User < ActiveRecord::Base
	# users.password in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash) if password_hash
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password_str)
    binding.pry
    return true if Password.new(password) == password_str
    false
  end
end
