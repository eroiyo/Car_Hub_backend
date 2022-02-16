# frozen_string_literal: true

require 'rails_helper'

describe 'Users GET #index', type: :request do
  it 'display a message if the user is not connected' do
    get '/member-data'
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['message']).to eq('You are not connected')
  end

  it 'display a message when the user register sucessfully' do
    post '/users/',
         params: {
           user: {
             email: 'test@example.com',
             password: '12345678'
           }
         }
    expect((response)).to have_http_status(:success)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['message']).to eq('Signed up sucessfully.')
  end
  it 'display a message when the user email or password are wrong' do
    post '/users/sign_in',
         params: {
           user: {
             email: 'idontexist@example.com',
             password: '12345678'
           }
         }
    expect((response)).to have_http_status(401)
    expect(response.body).to eq('Invalid Email or password.')
  end

  it 'display a message when the user connect and logout sucesfully' do
    post '/users/',
         params: {
           user: {
             email: 'test@example.com',
             password: '12345678'
           }
         }
    post '/users/sign_in',
         params: {
           user: {
             email: 'test@example.com',
             password: '12345678'
           }
         }
    expect((response)).to have_http_status(200)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['message']).to eq('You are logged test@example.com.')
    delete '/users/sign_out'
    User.delete_by(email: 'test@example.com')
  end
end
