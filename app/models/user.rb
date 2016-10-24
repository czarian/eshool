class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  ROLES = %i[admin regular]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, :format => { :with =>  /\A[A-Za-z\d_]+\z/ }
  validates :first_name, :last_name, length: { in: 3..20 }
end
