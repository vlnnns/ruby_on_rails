require 'json'
require 'yaml'

class BookCatalog
  attr_accessor :catalog

  def initialize
    @catalog = {}
  end

  def add_book(title, authors, genres)
    @catalog[title] = { authors: authors, genres: genres }
  end

  def edit_book(name, new_title, new_authors, new_genres)
    return puts 'Book not found' unless @catalog.key?(name)

    @catalog[new_title] = @catalog.delete(name) unless new_title.empty? || new_title == name
    updated_name = new_title.empty? ? name : new_title

    @catalog[updated_name][:authors] = new_authors.split(',').map(&:strip) unless new_authors.empty?
    @catalog[updated_name][:genres] = new_genres.split(',').map(&:strip) unless new_genres.empty?
  end

  def delete_book(name)
    @catalog.delete(name) || puts('Book not found')
  end

  def search_book(query)
    results = @catalog.select do |title, details|
      title.to_s.downcase.include?(query) ||
        details[:authors].any? { |a| a.downcase.include?(query) } ||
        details[:genres].any? { |g| g.downcase.include?(query) }
    end

    results.each do |title, details|
      puts "Name: #{title}, Authors: #{details[:authors].join(', ')}, Genres: #{details[:genres].join(', ')}"
    end
  end

  def save_to_file(filename, format)
    case format
    when :json
      File.write("#{filename}.json", JSON.pretty_generate(@catalog))
    when :yaml
      File.write("#{filename}.yml", @catalog.to_yaml)
    end
  end

  def output_books
    @catalog.each do |title, details|
      puts "\nTitle: #{title}"
      puts "Authors: #{details[:authors].join(', ')}"
      puts "Genres: #{details[:genres].join(', ')}"
    end
  end
end

class UserInterface
  def initialize(catalog)
    @catalog = catalog
  end

  def add_book
    print 'Book name: '
    title = gets.chomp.to_sym

    print 'Authors: '
    authors = gets.chomp.split(',').map(&:strip)

    print 'Genres: '
    genres = gets.chomp.split(',').map(&:strip)

    @catalog.add_book(title, authors, genres)
  end

  def edit_book
    print 'Enter book name: '
    name = gets.chomp.to_sym

    return puts 'Book not found' unless @catalog.catalog.key?(name)

    print 'Enter new name (or leave empty to not change): '
    new_title = gets.chomp.to_sym

    print 'Enter new authors (comma-separated, or leave empty to not change): '
    new_authors = gets.chomp

    print 'Enter new genres (comma-separated, or leave empty to not change): '
    new_genres = gets.chomp

    @catalog.edit_book(name, new_title, new_authors, new_genres)
  end

  def delete_book
    print 'Enter book name to delete: '
    name = gets.chomp.to_sym
    @catalog.delete_book(name)
  end

  def search_book
    print 'What are we searching for: '
    query = gets.chomp.downcase

    @catalog.search_book(query)
  end

  def save_to_file
    print 'Name of file to save (without extension): '
    filename = gets.chomp

    print 'Choose file format (1 for JSON, 2 for YAML): '
    format = gets.chomp.to_i == 1 ? :json : :yaml

    @catalog.save_to_file(filename, format)
  end

  def run
    loop do
      puts "\n1. Add book"
      puts '2. Edit book'
      puts '3. Delete book'
      puts '4. Search book'
      puts '5. Save to file'
      puts '6. Show catalog'
      puts '7. Exit'
      print 'Choose an option: '

      case gets.to_i
      when 1 then add_book
      when 2 then edit_book
      when 3 then delete_book
      when 4 then search_book
      when 5 then save_to_file
      when 6 then @catalog.output_books
      when 7 then break
      else puts 'Incorrect choice'
      end
    end
  end
end

catalog = BookCatalog.new
ui = UserInterface.new(catalog)
ui.run
