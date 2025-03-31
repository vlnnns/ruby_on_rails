require 'json'
require 'yaml'

catalog = {}

def add_book(catalog)
  print 'Book name: '
  title = gets.chomp.to_sym

  print 'Authors: '
  authors = gets.chomp.split(',').map(&:strip)

  print 'Genres: '
  genres = gets.chomp.split(',').map(&:strip)

  catalog[title] = { authors: authors, genres: genres }
end

def edit_book(catalog)
  print 'Enter book name: '
  name = gets.chomp.to_sym

  if catalog.key?(name)
    print 'Enter new name (or leave empty to not change): '
    new_title = gets.chomp.to_sym

    unless new_title.empty?
      catalog[new_title] = catalog.delete(name)
      name = new_title
    end

    print 'Enter new authors (comma-separated, or leave empty to not change): '
    new_authors = gets.chomp
    catalog[name][:authors] = new_authors.split(',').map(&:strip) unless new_authors.empty?

    print 'Enter new genres (comma-separated, or leave empty to not change): '
    new_genres = gets.chomp
    catalog[name][:genres] = new_genres.split(',').map(&:strip) unless new_genres.empty?
  else
    puts 'Book not found'
  end
end

def delete_book(catalog)
  print 'Enter book name to delete: '
  name = gets.chomp.to_sym
  catalog.delete(name) || puts('Book not found')
end

def search_book(catalog)
  print 'What are we searching for: '
  query = gets.chomp.downcase

  results = catalog.select do |title, details|
    title.to_s.downcase.include?(query) ||
      details[:authors].any? { |a| a.downcase.include?(query) } ||
      details[:genres].any? { |g| g.downcase.include?(query) }
  end

  puts "Found #{results.size} books:"
  results.each do |title, details|
    puts "Name: #{title}, Authors: #{details[:authors].join(', ')}, Genres: #{details[:genres].join(', ')}"
  end
end

def save_to_file(catalog, format)
  print 'Name of file to save (without extension): '
  filename = gets.chomp

  case format
  when :json
    File.write("#{filename}.json", JSON.pretty_generate(catalog))
  when :yaml
    File.write("#{filename}.yml", catalog.to_yaml)
  end
end

def load_from_file(format)
  print 'Name of file to load (without extension): '
  filename = gets.chomp

  case format
  when :json
    JSON.parse(File.read("#{filename}.json"), symbolize_names: true) rescue {}
  when :yaml
    YAML.load_file("#{filename}.yml", symbolize_names: true) rescue {}
  else
    {}
  end
end

loop do
  puts "\n1. Add book"
  puts '2. Edit book'
  puts '3. Delete book'
  puts '4. Search book'
  puts '5. Save to JSON'
  puts '6. Save to YAML'
  puts '7. Load from JSON'
  puts '8. Load from YAML'
  puts '9. Exit'
  print 'Choose an option: '

  case gets.to_i
  when 1 then add_book(catalog)
  when 2 then edit_book(catalog)
  when 3 then delete_book(catalog)
  when 4 then search_book(catalog)
  when 5 then save_to_file(catalog, :json)
  when 6 then save_to_file(catalog, :yaml)
  when 7 then catalog = load_from_file(:json)
  when 8 then catalog = load_from_file(:yaml)
  when 9 then break
  else puts 'Incorrect choice'
  end
end