class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.includes(:authors, :genres).all
  end

  def show; end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      process_authors_and_genres(@book)
      redirect_to @book, notice: 'Book was successfully saved'
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      process_authors_and_genres(@book)
      redirect_to @book, notice: 'Book was successfully updated'
    else
      render :edit
    end
  end


  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book is deleted'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, author_ids: [], genre_ids: [])
  end

  def process_authors_and_genres(book)
    authors = params[:author_names].to_s.split(',').map(&:strip).uniq
    book.authors = authors.map { |name| Author.find_or_create_by(name: name) }

    genres = params[:genre_names].to_s.split(',').map(&:strip).uniq
    book.genres = genres.map { |name| Genre.find_or_create_by(name: name) }

    book.save
  end

end
