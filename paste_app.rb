require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

require_all 'models'
require_all 'services/**/*.rb'
require_all 'lib/sinatra/**/*.rb'

class PasteApp < Sinatra::Base
  helpers Sinatra::AuthenticationHelper
  enable :logging
  set :port, '8080'

  get '/:name' do
    content_type :text

    paste = Paste.find_by(:name => params[:name])
    halt(404, 'Not found.') unless paste.present?

    paste.content
  end

  post '/api/pastes' do
    user = authenticate!

    service = JsonProcessorService.new
    service.input = request.body.read
    service.execute

    if service.errors
      content_type :text
      halt(422, 'Unprocessable JSON entity')
    end

    if service.paste.valid?
      service.paste.save!
      content_type :text
      halt 201
    else
      content_type :json
      halt(422, service.paste.errors.to_json)
    end
  end

  run! if app_file == $0
end
