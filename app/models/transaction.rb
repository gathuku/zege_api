class Transaction < ApplicationRecord
  #acts_as_token_authenticatable

  belongs_to :user
  
  validates :user_id, presence:true
  validates :made_to, presence:true
  validates :trans_type, presence:true
  validates :amount, presence:true

end
