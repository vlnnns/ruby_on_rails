class Book < ApplicationRecord
  has_many :authorships
  has_many :authors, through: :authorships

  has_many :book_genres
  has_many :genres, through: :book_genres

  validates :title, presence: true
end
