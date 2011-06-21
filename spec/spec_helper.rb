# encoding: UTF-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'main'))

# We need to explicitly require sinatra as rspec is geared more towards Rails
require 'sinatra'
require 'rspec'
require 'rack/test'


def app
  @app ||= Sinatra::Application
end

# RSpec.configure do |config|
  
  
  # set :environment => :test
  # Config goes here
  
  
  # config.
  
# end