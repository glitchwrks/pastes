require 'sinatra/activerecord/rake'
require './paste_app'

namespace :user do
  desc 'Create a new user for LOGIN with PASSWORD'
  task :create do
    user = User.create(
      :login => ENV['LOGIN'],
      :password => ENV['PASSWORD']
    )

    if user.errors.any?
      user.errors.messages.each { |field, errors| puts "Error on #{field.upcase}: #{errors.join(', ')}" }
    end
  end
end
