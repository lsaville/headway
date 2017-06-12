module Admin
  class UsersController < AdminController
    skip_before_action :require_admin!, only: [:stop_impersonating]
    respond_to :html, :json

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:success] = "Successfully updated #{@user.email}!"
        redirect_to admin_users_path
      else
        flash[:error] = 'Something went wrong!'
        redirect_to edit_admin_user_path(@user)
      end
    end

    def edit
      @user = User.find(params[:id])
      @roles = User.valid_roles
    end

    def new
      @user = User.new
      @roles = User.valid_roles
    end

    def create
      @user = User.create(user_params)
      if @user.save
        flash[:success] = "Successfully created user: #{@user.email}!"
        redirect_to admin_users_path
      else
        flash[:error] = 'Something went wrong!'
        redirect_to new_admin_user_path
      end
    end

    def index
      @users = User.all

      respond_with(@users)
    end

    def impersonate
      user = User.find(params[:id])
      track_impersonation(user, 'Start')
      impersonate_user(user)
      redirect_to root_path
    end

    def stop_impersonating
      track_impersonation(current_user, 'Stop')
      stop_impersonating_user
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit({ roles: [] },
                                   :first_name,
                                   :last_name,
                                   :password,
                                   :password_confirmation,
                                   :email)
    end

    def track_impersonation(user, status)
      analytics_track(
        true_user,
        "Impersonation #{status}",
        impersonated_user_id: user.id,
        impersonated_user_email: user.email,
        impersonated_by_email: true_user.email,
      )
    end
  end
end
