class UsersController < ApplicationController
  before_action :is_admin?, only: [:new, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(email: params[:user][:email])
    @user.password = params[:user][:password]
    if @user.save!
      redirect_to root_path
    else
      redirect_to new_user_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def is_admin?
      @current_user ||= User.find_by(id: session[:user_id])
      redirect_to root_path, notice: 'Login required.' unless @current_user

      true
    end

end
