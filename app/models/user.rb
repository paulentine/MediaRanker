class User < ApplicationRecord
  has_and_belongs_to_many :works

  validates :username, uniqueness: true
end
