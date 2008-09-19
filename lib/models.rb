require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "lib/frog.db"
)

class Blog < ActiveRecord::Base
  has_many :entries, :order => 'created_at DESC'
end

class Entry < ActiveRecord::Base
  belongs_to :blog
end