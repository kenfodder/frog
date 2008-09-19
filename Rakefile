Dir["lib/*.rb"].each { |x| load x }

task :default do
  puts 'rake frog:init           to get started'
  puts 'rake frog:reset          to reload the db schema'
end

namespace :frog do
  
  task :db_up do
    Schema.up
  end
  
  task :db_down do
    Schema.down
  end
  
  task :init => :db_up do
    Blog.create!(:title => 'My Blog') if Blog.count == 0
  end
  
  task :reset => [:db_down, :init]
  
end