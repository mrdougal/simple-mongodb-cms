configure do
  
	require 'ostruct'
	
	Site = OpenStruct.new(
	
		:name => 'A name for your site',
		:author => 'Dougal MacPherson',
		
    # Used for feed generation
		:url_base => 'http://mongo-talk.dev/',

    # Social media
    :twitter => 'mrdougal',

		:admin_password => 'secret',
		:admin_cookie_key => 'admin_cookie_key',
		:admin_cookie_value => '54l976913ace58'
		

	)
	
	
	Mongoid.configure do |config|

    config.allow_dynamic_fields = true

    # Setup configuration with logging enabled so that we can see the queries to the db
    # which is handy if you're wanting to know what happens under the hood
    # In a high performance setup you would want to turn logging off
    config.master = Mongo::Connection.new('localhost', 27017, :logger => Logger.new('logs/mongodb.log')).db('simple_cms')

  end
  
	
	
end