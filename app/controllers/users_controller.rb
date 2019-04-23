class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    successful = @user.save
    if successful
      redirect_to users_path
    else
      render :new, status: :bad_request
    end
  end

  def show
    user_id = params[:id]

    @user = User.find_by(id: user_id)

    unless @user
      head :not_found
    end
  end

  def edit
    user_id = params[:id]

    @user = User.find_by(id: user_id)

    unless @user
      head :not_found
    end
  end

  def update
    @user = User.find_by(id: params[:id])

    unless @user
      head :not_found
      return
    end

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    user_id = params[:id]

    user = User.find_by(id: user_id)

    unless user
      head :not_found
      return
    end

    user.deleted = !user.deleted

    user.save

    redirect_to users_path
  end

  private

  def user_params
    return params.require(:user).permit(:username)
  end

end
