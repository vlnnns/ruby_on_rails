class Catalog
  attr_accessor :books

  def initialize
    @books = []
  end

  def find_book(title)
    books.find { |book| book.title.downcase == title.downcase }
  end

  def add_book(book)
    books << book
  end

  def delete_book(title)
    book = find_book(title)
    books.delete(book) if book
  end

  def search_books(query)
    books.select do |book|
      book.title.downcase.include?(query.downcase) ||
        book.authors.any? { |a| a.name.downcase.include?(query.downcase) } ||
        book.genres.any? { |g| g.name.downcase.include?(query.downcase) }
    end
  end

  def list_books
    books.each { |book| puts book.to_s + "\n" }
  end
end
