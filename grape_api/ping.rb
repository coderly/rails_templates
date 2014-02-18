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