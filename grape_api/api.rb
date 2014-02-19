require 'grape-swagger'

class API < Grape::API
  prefix 'api'
  version 'v1'

  # helpers AuthenticationHelpers

  mount Reissued::PingService

  add_swagger_documentation :api_version => 'v1'
end