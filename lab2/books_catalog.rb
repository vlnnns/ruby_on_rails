require 'json'
require 'yaml'

# Declare catalog as a global variable
$catalog = {}

def add_book
  print 'Book name: '
  title = gets.chomp.to_sym

  print 'Authors: '
  authors = gets.chomp.split(',').map(&:strip)

  print 'Genres: '
  genres = gets.chomp.split(',').map(&:strip)

  $catalog[title] = { authors: authors, genres: genres }
end

def edit_book
  print 'Enter book name: '
  name = gets.chomp.to_sym

  return puts 'Book not found' unless $catalog.key?(name)

  print 'Enter new name (or leave empty to not change): '
  new_title = gets.chomp.to_sym
  $catalog[new_title] = $catalog.delete(name) unless new_title.empty? || new_title == name

  updated_name = new_title.empty? ? name : new_title

  print 'Enter new authors (comma-separated, or leave empty to not change): '
  new_authors = gets.chomp
  $catalog[updated_name][:authors] = new_authors.split(',').map(&:strip) unless new_authors.empty?

  print 'Enter new genres (comma-separated, or leave empty to not change): '
  new_genres = gets.chomp
  $catalog[updated_name][:genres] = new_genres.split(',').map(&:strip) unless new_genres.empty?
end

def delete_book
  print 'Enter book name to delete: '
  name = gets.chomp.to_sym
  $catalog.delete(name) || puts('Book not found')
end

def search_book
  print 'What are we searching for: '
  query = gets.chomp.downcase

  results = $catalog.select do |title, details|
    title.to_s.downcase.include?(query) ||
      details[:authors].any? { |a| a.downcase.include?(query) } ||
      details[:genres].any? { |g| g.downcase.include?(query) }
  end

  puts "Found #{results.size} books:"
  results.each do |title, details|
    puts "Name: #{title}, Authors: #{details[:authors].join(', ')}, Genres: #{details[:genres].join(', ')}"
  end
end

def save_to_file(format)
  print 'Name of file to save (without extension): '
  filename = gets.chomp

  case format
  when :json
    File.write("#{filename}.json", JSON.pretty_generate($catalog))
  when :yaml
    File.write("#{filename}.yml", $catalog.to_yaml)
  end
end

def output_books(collection)
  collection.each do |title, details|
    puts "\nTitle: #{title}"
    puts "Authors: #{details[:authors].join(', ')}"
    puts "Genres: #{details[:genres].join(', ')}"
  end
end

def show
  output_books($catalog)
end

loop do
  puts "\n1. Add book"
  puts '2. Edit book'
  puts '3. Delete book'
  puts '4. Search book'
  puts '5. Save to JSON'
  puts '6. Save to YAML'
  puts '7. Show catalog'
  puts '8. Exit'
  print 'Choose an option: '

  case gets.to_i
  when 1 then add_book
  when 2 then edit_book
  when 3 then delete_book
  when 4 then search_book
  when 5 then save_to_file(:json)
  when 6 then save_to_file(:yaml)
  when 7 then show
  when 8 then break
  else puts 'Incorrect choice'
  end
end
