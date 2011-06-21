
2011-06-21
Dougal MacPherson <hello@newfangled.com.au>

This is an example application to demonstrate some of the unique features of MongoDB to the Melbourne MongoDB users group. At the first meetup a lot of the members are curious about MongoDB but haven't used it before hand.

http://www.meetup.com/Melbourne-MongoDB-User-group/


** Please note that this application is not production ready **

This app is overly simplistic (there is no login) as it's mainly concerned with adding pages to db. A "real app" would have user logins and facilities for uploading images and logic for managing menus (to name a few features)

The application is written in ruby using the Sinatra web framework (http://sinatrarb.com/) so that there would be a minimal amount of code within the application. Regardless of your language you should find using MongoDB an exciting/liberating experience


To run this application you'll need ruby 1.8.6 (or greater) and bundler installed on your machine.
(and mongodb obviously)

Look at "Gemfile" to get started
