require 'rails_helper'

feature 'Create user as an admin' do
  scenario 'A form exists at admin/users/new' do
    user = create(:user, :admin)

    sign_in(user.email, user.password)
    visit new_admin_user_path

    expect(page).to have_content('Email')
    expect(page).to have_content('Roles')
  end
end
