require 'spec_helper'
require 'rack/test'

RSpec.describe 'Create Paste', :type => :feature do
  include Rack::Test::Methods

  def app
    PasteApp
  end

  let!(:valid_user) { FactoryBot.create(:user) }

  describe 'with valid JSON' do
    let(:valid_json) { {:name => "abcd1234", :content => "This is a test paste."}.to_json }

    describe 'but no auth credentials' do 
      before(:each) do
        post '/api/pastes', valid_json, "CONTENT_TYPE" => "application/json"
      end

      it { expect(last_response.status).to eq 401 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and invalid auth credentials' do
      before(:each) do
        authorize 'notauser', 'badpass'
        post '/api/pastes', valid_json, "CONTENT_TYPE" => "application/json"
      end

      it { expect(last_response.status).to eq 401 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to eq "Not authorized\n" }
    end

    describe 'and valid auth credentials' do
      before(:each) do
        authorize valid_user.login, 'testing'
        post '/api/pastes', valid_json, "CONTENT_TYPE" => "application/json"
      end

      it { expect(last_response.status).to eq 201 }
      it { expect(last_response.content_type).to start_with 'text/plain' }
      it { expect(last_response.body).to be_empty }
      it { expect(Paste.count).to eq 1 }
      it { expect(Paste.first.name).to eq 'abcd1234' }
      it { expect(Paste.first.content).to eq 'This is a test paste.' }

      describe 'but erroneous JSON data' do
        let(:duplicate_name_response) { {:name => ['has already been taken']}.to_json }

        before(:each) do
          authorize valid_user.login, 'testing'
          post '/api/pastes', valid_json, "CONTENT_TYPE" => "application/json"
        end

        it { expect(last_response.status).to eq 422 }
        it { expect(last_response.content_type).to start_with 'application/json' }
        it { expect(last_response.body).to eq duplicate_name_response }
        it { expect(Paste.count).to eq 1 }
      end
    end

  end

  describe 'with invalid JSON' do
    before(:each) do
      authorize valid_user.login, 'testing'
      post '/api/pastes'
    end

    it { expect(last_response.status).to eq 422 }
    it { expect(last_response.content_type).to start_with 'text/plain' }
    it { expect(last_response.body).to eq 'Unprocessable JSON entity' }
  end
end
