#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

Dir["lib/*.rb"].each { |x| load x }

before do
  @blog = Blog.find(:first)
end

get '/' do
  @entries = @blog.entries
  erb :blog
end

get '/new' do
  erb :new
end

post '/create' do
  entry = @blog.entries.create(:title => params[:title], :text => params[:text])
  redirect "/#{entry.id}"
end

get '/:id' do
  @entry = @blog.entries.find(params[:id])
  erb :entry
end

helpers do
  include Helpers
end