class User < ApplicationRecord
  has_secure_password

  before_validation :generate_confirmation_token, on: :create
  before_validation :downcase_email

  enum role: [:user, :admin]

  validates :email, presence: true,
                uniqueness: true,
                length: { maximum: 255 },
                format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  validates :password, presence: true, length: { minimum: 8 }, if: :new_record?
  validates :given_name, length: { maximum: 100 }
  validates :family_name, length: { maximum: 100 }
  validates :confirmation_token, presence: true,
                                 uniqueness: { case_sensitive: true }

  def confirm
     update_columns({
       confirmation_token: nil,
       confirmed_at: Time.now
     })
 end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

  def downcase_email
    email.downcase! if email
  end

end
