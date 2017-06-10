require 'rails_helper'

describe 'User API endpoints' do
  before(:each) do
    @user = create(:user, :admin)
  end

  describe 'Retrieve user list from API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 200' do
        get api_v1_users_url(user_email: @user.email,
                            user_token: @user.authentication_token), as: :json

        expect(response.status).to eq 200
      end

      it 'returns valid user JSON matching schema' do
        get api_v1_users_url(user_email: @user.email,
                            user_token: @user.authentication_token), as: :json

        expect(response).to match_response_schema('user')
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 200' do
        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        get api_v1_users_url, headers: token_header_params, as: :json

        expect(response.status).to eq 200
      end
      it 'returns value user JSON matching schema' do
        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        get api_v1_users_url, headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end

  describe 'Retrieve a single user from API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 200' do
        get api_v1_user_url(user_email: @user.email,
                            user_token: @user.authentication_token,
                            id: @user.id), as: :json

        expect(response.status).to eq 200
      end
      it 'returns a single user JSON matching schema' do
        get api_v1_user_url(user_email: @user.email,
                            user_token: @user.authentication_token,
                            id: @user.id), as: :json
        expect(response).to match_response_schema('user')
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 200' do
        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        get api_v1_user_url(id: @user.id), headers: token_header_params, as: :json

        expect(response.status).to eq 200
      end
      it 'returns a single user JSON matching schema' do
        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        get api_v1_user_url(id: @user.id), headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end

  describe 'Create a user via the API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 200' do
        new_user_data = {email: 'oprah@example.com',
                password: '12345678',
                password_confirmation: '12345678'}

        post api_v1_users_url(user_email: @user.email,
                              user_token: @user.authentication_token,
                              user: new_user_data), as: :json

        expect(response.status).to eq 201
      end
      it 'returns the new user JSON matching schema' do
        new_user_data = {email: 'oprah@example.com',
          password: '12345678',
          password_confirmation: '12345678'}

          post api_v1_users_url(user_email: @user.email,
          user_token: @user.authentication_token,
          user: new_user_data), as: :json

          expect(response).to match_response_schema('user')
        end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 200' do
        new_user_data = {email: 'oprah@example.com',
                password: '12345678',
                password_confirmation: '12345678'}

        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        post api_v1_users_url(user: new_user_data), headers: token_header_params, as: :json

        expect(response.status).to eq 201
      end
      it 'returns the new user JSON matching schema' do
        new_user_data = {email: 'oprah@example.com',
                password: '12345678',
                password_confirmation: '12345678'}

        token_header_params = { 'X-User-Email': @user.email,
                                'X-User-Token': @user.authentication_token }

        post api_v1_users_url(user: new_user_data), headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end
end
