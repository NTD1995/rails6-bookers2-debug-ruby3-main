class UsersController < ApplicationController
   before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update ,:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu| 
        @userEntry.each do |u| 
          if cu.room_id == u.room_id 
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
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
