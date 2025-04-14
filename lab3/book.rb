class Book
  attr_accessor :title, :authors, :genres

  def initialize(title)
    @title = title
    @authors = []
    @genres = []
  end

  def add_author(author)
    authors << author unless authors.include?(author)
  end

  def add_genre(genre)
    genres << genre unless genres.include?(genre)
  end

  def to_s
    "Title: #{title}\nAuthors: #{authors.map(&:name).join(', ')}\nGenres: #{genres.map(&:name).join(', ')}"
  end
end
