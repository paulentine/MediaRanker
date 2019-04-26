class Work < ApplicationRecord
  has_and_belongs_to_many :users

  def self.featured
    return Work.first
  end

  def self.top_ten(category)
    return Work.where(category: category).sample(10)
  end
end