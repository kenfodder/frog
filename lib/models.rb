require 'active_record'
require 'redcloth'
require 'syntaxi'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "lib/frog.db"
)

class Blog < ActiveRecord::Base
  has_many :entries, :order => 'created_at DESC'
end

class Entry < ActiveRecord::Base
  belongs_to :blog
  
  Syntaxi.line_number_method = 'floating'
  Syntaxi.wrap_at_column = 80
  
  def html
    html = RedCloth.new(self.text).to_html
    html = Syntaxi.new(html).process
  end
  
end