class UsersController < ApplicationController
  before_action :is_admin?
  before_action :set_user, only: [:edit, :destroy, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
     respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @user = User.new(email: params[:user][:email])
    @user.password = params[:user][:password]
    if @user.save!
      redirect_to users_path
    else
      redirect_to new_user_path
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def is_admin?
      @current_user ||= User.find_by(id: session[:user_id])
      redirect_to root_path, notice: 'Login required.' unless @current_user

      true
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
