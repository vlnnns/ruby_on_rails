require_relative 'book'
require_relative 'author'
require_relative 'genre'

class UserInterface
  def initialize(catalog)
    @catalog = catalog
  end

  def prompt(message)
    print message
    gets.chomp
  end

  def add_book
    title = prompt("Enter book title: ")
    book = Book.new(title)

    authors_input = prompt("Enter authors (comma-separated): ")
    authors_input.split(',').each do |a|
      book.add_author(Author.new(a))
    end

    genres_input = prompt("Enter genres (comma-separated): ")
    genres_input.split(',').each do |g|
      book.add_genre(Genre.new(g))
    end

    @catalog.add_book(book)
    puts "Book added!"
  end

  def delete_book
    title = prompt("Enter title of book to delete: ")
    @catalog.delete_book(title)
    puts "Book deleted if it existed."
  end

  def search_books
    query = prompt("Enter search query: ")
    results = @catalog.search_books(query)
    results.each { |book| puts book.to_s + "\n" }
  end

  def list_books
    @catalog.list_books
  end

  def run
    loop do
      puts "\n1. Add book"
      puts "2. Delete book"
      puts "3. Search book"
      puts "4. Show all books"
      puts "5. Exit"
      print "Choose an option: "

      case gets.to_i
      when 1 then add_book
      when 2 then delete_book
      when 3 then search_books
      when 4 then list_books
      when 5 then break
      else puts "Invalid choice."
      end
    end
  end
end
