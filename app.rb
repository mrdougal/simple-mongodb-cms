require 'sinatra'
require 'mongoid'
require 'erb'


get "/" do
  
  @output = 'Hello world'
  erb :app
end