require 'rails_helper'

describe 'User API endpoints' do
  let(:admin_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe 'Retrieve user list from API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 200' do
        get api_v1_users_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
        ), as: :json

        expect(response.status).to eq 200
      end

      it 'returns valid user JSON matching schema' do
        get api_v1_users_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
        ), as: :json

        expect(response).to match_response_schema('user')
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 200' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        get api_v1_users_url, headers: token_header_params, as: :json

        expect(response.status).to eq 200
      end
      it 'returns value user JSON matching schema' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        get api_v1_users_url, headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end

  describe 'Retrieve a single user from API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 200' do
        get api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: admin_user.id,
        ), as: :json

        expect(response.status).to eq 200
      end
      it 'returns a single user JSON matching schema' do
        get api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: admin_user.id,
        ), as: :json

        expect(response).to match_response_schema('user')
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 200' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        get api_v1_user_url(
          id: user.id,
        ), headers: token_header_params, as: :json

        expect(response.status).to eq 200
      end
      it 'returns a single user JSON matching schema' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        get api_v1_user_url(
          id: admin_user.id,
        ), headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end

  describe 'Create a user via the API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 201' do
        new_user_data = { email: 'oprah@example.com',
                          password: '12345678',
                          password_confirmation: '12345678' }

        post api_v1_users_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          user: new_user_data,
        ), as: :json

        expect(response.status).to eq 201
      end
      it 'returns the new user JSON matching schema' do
        new_user_data = {
          email: 'oprah@example.com',
          password: '12345678',
          password_confirmation: '12345678',
        }

        post api_v1_users_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          user: new_user_data,
        ), as: :json

        expect(response).to match_response_schema('user')
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 201' do
        new_user_data = {
          email: 'oprah@example.com',
          password: '12345678',
          password_confirmation: '12345678',
        }

        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        post api_v1_users_url(
          user: new_user_data,
        ), headers: token_header_params, as: :json

        expect(response.status).to eq 201
      end
      it 'returns the new user JSON matching schema' do
        new_user_data = {
          email: 'oprah@example.com',
          password: '12345678',
          password_confirmation: '12345678',
        }

        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        post api_v1_users_url(
          user: new_user_data,
        ), headers: token_header_params, as: :json

        expect(response).to match_response_schema('user')
      end
    end
  end

  describe 'Update the user via the API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 204' do
        updated_user_data = { email: 'alejandro@example.com' }

        put api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: admin_user.id,
          user: updated_user_data,
        ), as: :json

        expect(response.status).to eq 204
      end

      it 'returns nothing and updates the user' do
        old_email = user.email
        updated_user_data = { email: 'alejandro@example.com' }

        put api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: user.id,
          user: updated_user_data,
        ), as: :json

        new_email = User.find(user.id).email

        expect(response.body).to eq('')
        expect(old_email).to_not eq(new_email)
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 204' do
        updated_user_data = { email: 'alejandro@example.com' }

        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        put api_v1_user_url(
          user: updated_user_data,
          id: user.id,
        ), headers: token_header_params, as: :json

        expect(response.status).to eq 204
      end
      it 'returns nothing and updates the user' do
        old_email = user.email
        updated_user_data = { email: 'alejandro@example.com' }

        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        put api_v1_user_url(
          user: updated_user_data,
          id: user.id,
        ), headers: token_header_params, as: :json

        new_email = User.find(user.id).email

        expect(response.body).to eq('')
        expect(old_email).to_not eq(new_email)
      end
    end
  end

  describe 'Destroy a user via the API', type: :request do
    context 'with token authentication via query params' do
      it 'returns status code 204' do
        delete api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: user.id,
        ), as: :json

        expect(response.status).to eq 204
      end
      it 'returns an empty JSON string and destroys the user' do
        delete api_v1_user_url(
          user_email: admin_user.email,
          user_token: admin_user.authentication_token,
          id: user.id,
        ), as: :json

        expect(User.count).to eq 1
        expect(User.first.email).to eq(admin_user.email)
      end
    end

    context 'with token authentication via request headers' do
      it 'returns status code 204' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        delete api_v1_user_url(
          id: user.id,
        ), headers: token_header_params, as: :json

        expect(response.status).to eq 204
      end
      it 'returns an empty JSON string and destroys the user' do
        token_header_params = {
          'X-User-Email': admin_user.email,
          'X-User-Token': admin_user.authentication_token,
        }

        delete api_v1_user_url(
          id: user.id,
        ), headers: token_header_params, as: :json

        expect(User.count).to eq 1
        expect(User.first.email).to eq(admin_user.email)
      end
    end
  end
end
