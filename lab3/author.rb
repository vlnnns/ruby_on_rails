class Author
  attr_accessor :name

  def initialize(name)
    @name = name.strip
  end
end
