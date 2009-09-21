# Rails template similar to Suspenders

# Application gems
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'thoughtbot-clearance', :lib => 'clearance', :source => 'http://gems.github.com'
gem 'justinfrench-formtastic', :lib => 'formtastic', :source => 'http://gems.github.com'
gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com'
gem 'chriseppstein-compass', :lib => 'compass', :source => 'http://gems.github.com'
gem 'josevalim-inherited_resources', :lib => 'inherited_resources', :source => 'http://gems.github.com'
gem 'giraffesoft-enum_field', :lib => 'enum_field', :source => 'http://gems.github.com'
gem 'josevalim-inherited_resources', :lib => 'inherited_resources', :source => 'http://gems.github.com'

# Testing gems
gem "cucumber", :lib => false, :version => ">= 0.3.98"
gem "webrat", :lib => false, :version => ">= 0.4.4"
gem 'thoughtbot-shoulda', :lib => 'shoulda', :version => '>= 2.10.2', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :version => '>= 1.2.2', :source => 'http://gems.github.com'
gem 'rr', :version => '>= 0.10.0', :source => 'http://gems.rubyforge.org'
gem 'faker', :version => '>= ', :source => 'http://gems.rubyforge.org'
gem 'jnunemaker-matchy', :lib => false, :version => '>= 0.4.0', :source => 'http://gems.github.com'

# Make sure the gems are installed
rake("gems:install", :sudo => true)

# Prompt to unpack these gems
rake("gems:unpack") if yes?("Unpack rails gems ?")

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

# Get Clearance installed (overwrite any existing Cucumber files)
generate("clearance")
generate("clearance_features", '-f')
route "map.root :controller => :home"
environment 'HOST = "localhost"'
environment 'DO_NOT_REPLY = "vikram@swiftsignal.com"'

# Clearance will want to set up the database
rake "db:migrate"

# Remove the default page
run "rm public/index.html"

# Git going!
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
