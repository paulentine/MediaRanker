class Work < ApplicationRecord
  has_and_belongs_to_many :users

  def self.featured
    return Work.first
  end

  def self.top_ten_albums
    return Work.where(category: "album").sample(10)
  end

  def self.top_ten_books
    return Work.where(category: "book").sample(10)
  end

  def self.top_ten_movies
    return Work.where(category: "movie").sample(10)
  end
end
