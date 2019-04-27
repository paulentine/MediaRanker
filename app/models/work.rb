class Work < ApplicationRecord
  has_and_belongs_to_many :users

  validates :title, presence: true, uniqueness: true

  def self.not_deleted
    return Work.where(deleted: false)
  end

  def self.featured
    return not_deleted.all.max_by { |work| work.users.count }
  end

  def self.top_ten(category)
    category_works = not_deleted.where(category: category).sort_by { |work| work.users.count }
    cat_works = category_works.reverse
    if cat_works.length >= 10
      return cat_works.first(10)
    else
      return cat_works
    end
  end
end