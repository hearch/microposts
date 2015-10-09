class UsersController < ApplicationController

  def index
    @users = User.all.page params[:page]
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page params[:page]
  end
   
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def followings
      @user = User.find(params[:id])
      @followings = @user.following_users.page params[:page]
  end

  def followers
      @user = User.find(params[:id])
      @followers = @user.follower_users.page params[:page]
  end
  
  def favorites
      @user = User.find(params[:id])
      @favorites = @user.favorite_microposts.page params[:page]
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :prefecture, :profile)
  end
end
