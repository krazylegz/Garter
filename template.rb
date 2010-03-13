# Rails template similar to Suspenders

# Application gems
gem 'will_paginate', :lib => 'will_paginate', :source => 'http://gemcutter.org'
gem 'formtastic', :lib => 'formtastic', :source => 'http://gemcutter.org'
gem 'paperclip', :lib => 'paperclip', :source => 'http://gemcutter.org'
gem 'compass', :lib => 'compass', :source => 'http://gemcutter.org'
gem 'enum_field', :lib => 'enum_field', :source => 'http://gemcutter.org'
gem 'dry_scaffold', :lib => false, :source => 'http://gemcutter.org'
gem 'clearance', :lib => 'clearance', :source => 'http://gemcutter.org', :version => '0.8.8'
gem 'inherited_resources', :lib => 'inherited_resources', :source => 'http://gemcutter.org', :version => '1.0.3'
gem 'responders', :source => 'http://gemcutter.org', :version => '0.4.3'

# Testing gems
gem "cucumber", :lib => false, :version => ">= 0.3.98", :source => 'http://gemcutter.org', :env => :test
gem "webrat", :lib => false, :version => ">= 0.4.4", :source => 'http://gemcutter.org', :env => :test
gem 'shoulda', :lib => 'shoulda', :version => '>= 2.10.2', :source => 'http://gemcutter.org', :env => :test
gem 'factory_girl', :lib => 'factory_girl', :version => '>= 1.2.2', :source => 'http://gemcutter.org', :env => :test
gem 'rr', :version => '>= 0.10.0', :source => 'http://gemcutter.org', :env => :test
gem 'faker', :version => '>= ', :source => 'http://gemcutter.org', :env => :test
gem 'jnunemaker-matchy', :lib => false, :version => '>= 0.4.0', :source => 'http://gemcutter.org', :env => :test

# Make sure the gems are installed
if yes?("Install gems with sudo?")
  rake "gems:install", :sudo => true
else
  rake "gems:install"
end

# Prompt to unpack these gems
rake("gems:unpack") if yes?("Unpack rails gems?")

# Create a default controller
file 'app/controllers/home_controller.rb', 'class HomeController < ApplicationController
end'

# Create a default view
run 'mkdir app/views/home'
file 'app/views/home/index.html.haml', '%h2 Home'

# Create a default layout
file 'app/views/layouts/application.html.haml', '!!!
%html{ :xmlns => "http://www.w3.org/1999/xhtml" }
  %head
    %meta(http-equiv="content-type" content="text/html;charset=UTF-8")
    %title My Site
  %body
    - if flash.present?
      #flash= flash[:failure] || flash[:notice] || flash[:success]
    = yield'

# Generate some initial Cucumber stuffs
generate("cucumber")

# And now we add factory_girl to cucumber.rb
gem 'factory_girl', :lib => 'factory_girl', :version => '>= 1.2.2', :source => 'http://gemcutter.org', :env => :cucumber

# Get Clearance installed (overwrite any existing Cucumber files)
generate("clearance")
generate("clearance_features", '-f')
route "map.root :controller => :home"
route "Clearance::Routes.draw(map)"
environment 'HOST = "localhost"'
environment 'DO_NOT_REPLY = "vikram@swiftsignal.com"'
environment "config.action_mailer.default_url_options = { :host => 'localhost' }", :env => :cucumber
initializer 'clearance.rb', <<-CODE
Clearance.configure do |config|
  config.mailer_sender = 'vikram@swiftsignal.com'
end
CODE

# This is a hack to fix the way Clearance currently misuses ActionMailer in Clearance 0.8.5
gsub_file 'features/step_definitions/clearance_steps.rb', /ActionMailer::Base.deliveries.first/, 'ActionMailer::Base.deliveries.last'

# Clearance will want to set up the database
rake "db:migrate"

# Enable the Dry Scaffold Rake task
run "echo require \"'dry_scaffold/tasks'\" >> Rakefile"

# Remove the default page
run "rm public/index.html"

# Git going!
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
