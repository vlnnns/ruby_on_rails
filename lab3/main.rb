require_relative 'catalog'
require_relative 'user_interface'

catalog = Catalog.new
ui = UserInterface.new(catalog)
ui.run
