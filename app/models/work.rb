class Work < ApplicationRecord
  has_and_belongs_to_many :users

  validates :title, uniqueness: true

  def self.featured
    return Work.first.where(deleted: false)
  end

  def self.top_ten(category)
    return Work.where(category: category, deleted: false).sample(10)
  end
end