require File.join(File.dirname(__FILE__), '../..', 'main.rb')
# require 'rspec'


describe 'Page' do
  
  
  describe "generation of slug" do
    
    before(:each) do
      @page = Page.new :title => 'Bacon Cheese and Ham'
      @page.valid?
    end
    
    it "should downcase the letters and replace spaces with '-'" do
      @page.slug.should == 'bacon-cheese-and-ham'
    end
    
  end
  
  
  describe "requires a title" do
    
    before(:each) do
      @page = Page.new
      @page.valid?
    end
    
    it "should require a title" do
      @page.errors[:title].should_not be_nil
    end
    
    it "should not be valid" do
      @page.should_not be_valid
    end
    
  end
  
end