require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe '#edit and #update' do
    context 'admin' do
      it 'loads the page to update a user' do
        sign_in(admin_user)
        get edit_admin_user_path(user)
        expect(response).to be_success
      end

      it 'updates the user and redirects to the index' do
        sign_in(admin_user)

        updated_user_data = { email: 'meow@example.com' }

        put admin_user_path(user, user: updated_user_data)

        expect(response.status).to eq 302
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'user' do
      it 'redirects the unauthorized user' do
        sign_in(user)
        get admin_users_path
        expect(response).to be_redirect

        txt = 'You must be an admin to perform that action'
        expect(flash[:alert]).to eq(txt)
      end
    end

    context 'NOT authenticated' do
      it 'redirects to sign in page with an alert' do
        get admin_users_path
        expect(response).to be_redirect

        txt = 'You need to sign in or sign up before continuing.'
        expect(flash[:alert]).to eq(txt)
      end
    end
  end

  describe '#new and #create' do
    context 'admin' do
      it 'loads the page to create a user' do
        sign_in(admin_user)
        get new_admin_user_path
        expect(response).to be_success
      end

      it 'creates a user and redirects to the index' do
        sign_in(admin_user)

        new_user_data = { first_name: 'Michael',
                          last_name: 'Jackson',
                          email: 'mj@example.com',
                          password: 'lkjfdsa321',
                          password_confirmation: 'lkjfdsa321' }

        post admin_users_path(user: new_user_data)

        expect(response.status).to eq 302
        expect(response).to redirect_to(admin_users_path)
      end

      it 'redirects back without a validated field' do
        sign_in(admin_user)

        new_user_data = { first_name: 'Michael',
                          last_name: 'Jackson',
                          password: 'lkjfdsa321',
                          password_confirmation: 'lkjfdsa321' }

        post admin_users_path(user: new_user_data)

        expect(response.status).to eq 302
        expect(response).to redirect_to(new_admin_user_path)
      end
    end

    context 'user' do
      it 'redirects the unauthorized user' do
        sign_in(user)
        get admin_users_path
        expect(response).to be_redirect

        txt = 'You must be an admin to perform that action'
        expect(flash[:alert]).to eq(txt)
      end
    end

    context 'NOT authenticated' do
      it 'redirects to sign in page with an alert' do
        get admin_users_path
        expect(response).to be_redirect

        txt = 'You need to sign in or sign up before continuing.'
        expect(flash[:alert]).to eq(txt)
      end
    end
  end

  describe '#index' do
    context 'authenticated' do
      context 'admin' do
        it 'loads all users in the browser' do
          sign_in(admin_user)
          get admin_users_path
          expect(response).to be_success
        end

        it 'lists all users as json' do
          token_header_params = {
            'X-User-Email': admin_user.email,
            'X-User-Token': admin_user.authentication_token,
          }

          get admin_users_url, headers: token_header_params, as: :json

          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:success)
        end
      end

      context 'user' do
        it 'redirects with an alert that you need to be an admin' do
          sign_in(user)
          get admin_users_path
          expect(response).to be_redirect

          txt = 'You must be an admin to perform that action'
          expect(flash[:alert]).to eq(txt)
        end
      end
    end

    context 'NOT authenticated' do
      it 'redirects to sign in page with an alert' do
        get admin_users_path
        expect(response).to be_redirect

        txt = 'You need to sign in or sign up before continuing.'
        expect(flash[:alert]).to eq(txt)
      end
    end
  end

  describe '#impersonate' do
    it 'changes the current user from admin to the specified user' do
      sign_in(admin_user)
      get impersonate_admin_user_path(user)
      expect(controller.current_user).to eq(user)
    end
  end

  describe '#stop_impersonating' do
    it 'returns the current_user to the admin user' do
      sign_in(admin_user)
      get impersonate_admin_user_path(user)
      expect(controller.current_user).to eq(user)
      get stop_impersonating_admin_users_path
      expect(controller.current_user).to eq(admin_user)
    end
  end
end
