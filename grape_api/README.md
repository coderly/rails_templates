###Setup Hipchat room
- [ ] Go to lobby and click “Create Room”
- [ ] Invite people to the room

###Create a new rails project
- [ ] rails new product_name
- [ ] initial commit of rails project

###Setup repository for GitHub
- [ ] Name it product-name-api
- [ ] Setup GitHub hook to send notifications to hipchat

    - [ ] https://coderly.hipchat.com/admin/api
    - [ ] Add a new notification token named ‘product-name-github’
    - [ ] Go to the GitHub repo settings and add your token. Be sure to enable active and notify.
    
- [ ] Push initial commit
- [ ] Create development branch (identical to master branch) and push that also. You will be working from the development branch.
- [ ] Verify that the HipChat hook works
- [ ] Invite collaborators to the project (e.g. the coderly/developers team)

### Local environment (gems and dependencies)
- [ ] Create an rvm gemset with the name of your product
- [ ] Add this to your Gemfile `ruby '2.1'`
- [ ] Make sure you have the latest version of rails in your Gemfile
- [ ] Setup database

    - [ ] gem 'pg' for postgres (remove the sqlite gem)
    - [ ] create database product_name_test and product_name_development
    - [ ] make sure database.yml is in the .gitignore file
    - [ ] Update database.yml (sample: http://bit.ly/1gwe8JS)
    - [ ] run `rails s` to make sure the server runs properly
    
- [ ] Add to Gemfile: rails_12factor in :production
- [ ] Add to Gemfile: dotenv-rails in :production and :test
- [ ] create a .env file and add it to .gitignore
- [ ] Add to Gemfile: pry and pry-nav in :development and :test
- [ ] Add to Gemfile: rspec-rails in :development
- [ ] bundle install

### Grape API

- [ ] Add to Gemfile: latest version of grape
- [ ] Add to Gemfile: latest version of grape-swagger
- [ ] Add to Gemfile: latest version of present gem
    
    - `gem 'present', github: 'coderly/present'` (you can reference gems by their github path)
    
- [ ] Create an app/api/product_name folder

- [ ] Create a ping service in ping.rb

```ruby
# app/api/product_name/ping_service.rb
module ProductName
  class PingService < Grape::API
    format :json

    desc 'Returns pong.'
    params do
      requires :pong, type: String, desc: 'The string to be ponged.'
    end
    get 'ping' do
      { :ping => params[:pong] || 'pong' }
    end
  end
end
```
    
```ruby
# app/api/api.rb
require 'grape-swagger'
require_relative './helpers/authentication_helpers'
class API < Grape::API
  version 'v1'

  mount ProductName::PingService

  add_swagger_documentation :api_version => 'v1'
end
```

- [ ] mount the api under /api in routes.rb
- [ ] run rails s to see that everything works
- [ ] navigate to /api/v1/ping in your browser to make sure that you get back a json response as you expect

### Deploy to Heroku
- [ ] create free accounts on heroku for staging and production
- [ ] name them product-name-staging and product-name-production
- [ ] add github hipchat hooks so deploys get logged to hipchat
- [ ] add production and staging as remotes to the github repository
- [ ] push the development branch to staging. (this will be the first & last time that you push directly to staging... except for critical emergencies)
- [ ] add collaborators to accounts

### Continuous Integration
#### First test
- [ ] Create a new feature by typing `code start test ping service` into the command line
- [ ] Create your first spec for the ping service. Test that it is returning the current time
```ruby
require 'spec_helper'

module ProductName
  describe PingService do

    describe 'GET /api/v1/ping' do

      it 'should pong the pinged string' do
        get '/api/v1/ping', pong: 'pong'
        response.body.should == { :ping => "pong" }.to_json
      end

    end

  end
end
```
- [ ] Make sure the spec is failing
- [ ] Type `code publish` in the console so that it pushes this feature branch creates a pull request
- [ ] In the description of the pull request, type "Get continuous integration working with CircleCI"
- [ ] Add a circle.yml to the top-level directory of the project. This will allow us to auto-deploy when the tests pass
```yaml
database:
  override:
    - mv config/database.ci.yml config/database.yml
    - bundle exec rake db:schema:load --trace
deployment:
  staging:
    branch: development
    commands:
      - git push git@heroku.com:product-name-staging.git $CIRCLE_SHA1:master
      - heroku run rake db:migrate --app app-name-development
  production:
    branch: master
    commands:
      - git push git@heroku.com:product-name-production.git $CIRCLE_SHA1:master
      - heroku run rake db:migrate --app app-name-production
```
- [ ] Make sure all the names match up with the app names and the repository names
- [ ] Add a database.ci.yml in the same directory as where database.yml is
```ruby
test:
  adapter: postgis
  host: 127.0.0.1
  encoding: unicode
  database: circle_test
  username: ubuntu
  password:
  postgis_extension: true
  pool: 5
```
- [ ] Commit circle.yml and database.ci.yml to database. They should not be in .gitignore
- [ ] Add the repository to CircleCI
    - Click + Project and click setup on the project
    - Click on Heroku under Continuous Deployment and go through the process they describe
- [ ] Setup HipChat hooks so that CircleCI success/failed gets tied in to the activity stream
- [ ] Push your build to github and go to circle to see if the test is getting run. It should fail.
- [ ] Check that the test failed message is showing up on the github pull request
- [ ] Make the test pass on your local machine and push up a new commit to your pull request.
- [ ] Check that the test passed on circle and that the github pull request has a check mark meaning that the tests on your branch passed
- [ ] Add a comment to a line of code in your pull request and make sure that it shows up in hipchat
- [ ] Click the green merge button and then delete branch to merge your pull request
- [ ] Make sure these notices showed up in hipchat
- [ ] Check on CircleCI to see that the development branch is getting tested
- [ ] Make sure CircleCI deploys the code to staging
- [ ] Type `code finish` to delete your local branch and switch back to development

#### Setup swagger browser
- [ ] Put swagger browser under public/swagger
    - https://github.com/coderly/getculinary/tree/development/public
- [ ] Test it by making sure you can go to swagger and call the /ping api
- [ ] Create a new pull request for swagger browser and follow the same procedure to merge it into development
- [ ] Go to the /swagger url on staging and test to see that /ping works on staging also
