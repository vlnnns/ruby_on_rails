require 'json'
require 'yaml'


def add_book(collection, title, authors, genres)
  collection[title.to_sym] = { authors: authors, genres: genres }
end

def edit_book(collection, title, new_authors = nil, new_genres = nil)
  return unless collection.key?(title.to_sym)

  collection[title.to_sym][:authors] = new_authors unless new_authors.nil?
  collection[title.to_sym][:genres] = new_genres unless new_genres.nil?
end

def delete_book(collection, title)
  collection.delete(title.to_sym)
end

def search_books(collection, keyword)
  collection.select do |title, details|
    title.to_s.downcase.include?(keyword.downcase) ||
      details[:authors].any? { |a| a.downcase.include?(keyword.downcase) } ||
      details[:genres].any? { |g| g.downcase.include?(keyword.downcase) }
  end
end

def output_books(collection)
  collection.each do |title, details|
    puts "\nTitle: #{title}"
    puts "Authors: #{details[:authors].join(', ')}"
    puts "Genres: #{details[:genres].join(', ')}"
  end
end

def save_to_json(collection, filename)
  File.write(filename, JSON.pretty_generate(collection))
end

def load_from_json(filename)
  JSON.parse(File.read(filename), symbolize_names: true) rescue {}
end

def save_to_yaml(collection, filename)
  File.write(filename, collection.to_yaml)
end

def load_from_yaml(filename)
  YAML.load_file(filename, symbolize_names: true) rescue {}
end

def main
  books = load_from_json("books.json")

  add_book(books, "Dune", ["Frank Herbert"], ["Sci-Fi"])
  add_book(books, "The Hobbit", ["J.R.R. Tolkien"], ["Fantasy"])
  edit_book(books, "Dune", ["Frank Herbert"], ["Science Fiction"])
  delete_book(books, "The Hobbit")

  puts "\nSearch results for 'dune':"
  p search_books(books, "dune")

  puts "\nCurrent book catalog:"
  output_books(books)

  save_to_json(books, "books.json")
  save_to_yaml(books, "books.yml")
end

main if __FILE__ == $0
