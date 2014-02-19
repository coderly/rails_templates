# Reissued API

[![Build Status](https://circleci.com/gh/coderly/project-name/tree/development.png?circle-token=TOKEN)](https://circleci.com/gh/coderly/project-name)

[![Dependency Status](https://gemnasium.com/GET_CORRECT_URL.png)](https://gemnasium.com/coderly/project-name)

## Starting the server

Install Zeus with `gem install zeus`.

Running `zeus start` will not start up the Rails server.

You'll need to install foreman with `gem install foreman`, and then run `foreman start`. This will start up the unicorn process as specified in the `Procfile` to most closely mimic the Heroku server.