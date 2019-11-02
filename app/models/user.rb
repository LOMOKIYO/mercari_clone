class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]

      user.save(:validate => false)
    end
  end

  has_many :comments
  has_many :items

  validates :nickname, presence: true
  validates :nickname, length: { maximum: 20 }
  validates :password, length: { minimum: 7 }
  validates :password_confirmation, presence: true, length: { minimum: 7 }
end