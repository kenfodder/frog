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
  @blog.entries.create(:text => params[:text])
  redirect '/'
end

get '/:id' do
  @entry = Entry.find(params[:id])
  erb :entry
end

helpers do
  include Helpers
end