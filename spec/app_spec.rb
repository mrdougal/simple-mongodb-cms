# encoding: UTF-8
require File.dirname(__FILE__) + '/spec_helper'


describe 'Main' do
  
  include Rack::Test::Methods
  

  it "should be homepage" do
    get '/'
    last_response.should be_ok
    
  end

  it "should be ok for 'new'" do
    
    get '/new'
    last_response.should be_ok
    
  end


  describe "missing pages" do
    
    it "should be 404 for 'no-page-by-this-name'" do
  
      get '/no-page-by-this-name'
      last_response.status.should == 404
  
    end

    it "should be missing for '/no-page-by-this-name/edit'" do
    
      get '/about/no-page-by-this-name'
      last_response.status.should == 404
    end

  end
  

  
end