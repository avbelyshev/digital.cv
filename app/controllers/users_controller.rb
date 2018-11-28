class UsersController < ApplicationController
  before_action :load_user, except: %i[index new create]
  before_action :require_user!, only: %i[edit update]

  def index
    @users = User.all
  end

  def show; end

  def new
    redirect_to root_url, alert: 'You are already logged in' if current_user.present?
    @user = User.new
  end

  def create
    redirect_to root_url, alert: 'You are already logged in' if current_user.present?
    @user = User.new(user_params)

    if @user.save
      session = build_passwordless_session(@user)

      Passwordless::Mailer.magic_link(session).deliver_now if session.save

      render 'passwordless/sessions/create'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Data updated'
    else
      render 'edit'
    end
  end

  private

  def load_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
