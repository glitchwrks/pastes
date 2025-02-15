require 'spec_helper'
require 'rack/test'

RSpec.describe 'PasteApp', :type => :feature do
  include Rack::Test::Methods

  def app
    PasteApp
  end

  let!(:paste) { FactoryBot.create(:valid_paste) }

  describe 'when getting a nonexistent Paste' do
    before(:each) do
      get '/notpaste'
    end

    it { expect(last_response.content_type).to eq 'text/plain;charset=utf-8' }
    it { expect(last_response.status).to eq 404 }
    it { expect(last_response.body).to eq 'Not found.' }
  end

  describe 'when getting a valid Paste' do
    before(:each) do
      get "/#{paste.name}"
    end

    it { expect(last_response.content_type).to eq 'text/plain;charset=utf-8' }
    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.body).to eq paste.content }
  end
end
