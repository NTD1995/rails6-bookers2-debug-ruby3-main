class UsersController < ApplicationController
   before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update ,:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
     @user = User.find(params[:id]) 
  render :edit 
  end

  def update
     @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      @books = Book.all
      render "edit"
    end
  end

    def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  def followeds
    user = User.find(params[:id])
    @users = user.followeds
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
