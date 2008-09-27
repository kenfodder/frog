#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

Dir["lib/*.rb"].each { |x| load x }

configure do
  set_option :sessions, true
end

before do
  if request.path_info =~ /admin/ and !logged_in?
    session['forward'] = request.path_info + (request.query_string.blank? ? '' : '?' + request.query_string)
    redirect '/login'
  end
  @blog = Blog.find(:first)
end

helpers do
  include Helpers
end

# Main Blog action
get '/' do
  @entries = @blog.entries
  erb :blog
end

# Permalink Entry action
get '/perm/:id' do
  @entry = @blog.entries.find(params[:id])
  erb :entry
end

get '/login' do
  erb :login
end

post '/login' do
  # TODO: store the hashed password on the blog model
  if params[:username] == 'admin' and params['password'] == 'admin'
    session[:user] = true
    redirect session['forward'] || '/'
  else
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

# -- Admin actions (require login)

get '/admin' do
  @entries = @blog.entries
  erb :admin
end

get '/admin/new' do
  erb :new
end

post '/admin/create' do
  entry = @blog.entries.create(
    :title => params[:title],
    :url => params[:url],
    :text => params[:text]
  )
  redirect "/perm/#{entry.id}"
end

# For use by the bookmarklet
# http://blog/admin/bookmark?url=http://somewhere.com/
get '/admin/bookmark' do
  url = params[:url]
  title = scrape_page_title(url)
  @blog.entries.create(
    :title => title, 
    :url => url
  )
  redirect url
end
