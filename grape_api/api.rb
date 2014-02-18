require 'grape-swagger'
require_relative './helpers/authentication_helpers'
class API < Grape::API
  prefix 'api'
  version 'v1'

  helpers AuthenticationHelpers

  mount ProductName::PingService

  add_swagger_documentation :api_version => 'v1'
end