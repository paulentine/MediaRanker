class UsersController < ApplicationController
  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]

    user = User.find_by(username: username)
    unless user
      # new user
      user = User.create(username: username)

      # TODO: what if creating the user failed?
      unless user
        flash.now[:status] = :error
        flash.now[:message] = "Username #{user.username} is already taken, please try again"
        render :new, status: :bad_request
      end
    end

    session[:user_id] = user.id

    flash[:status] = :success
    flash[:message] = "Successfully logged in as user #{user.username}"

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil

    flash[:status] = :success
    flash[:message] = "Successfully logged out"

    redirect_to root_path
  end

  def current
    @user = User.find_by(id: session[:user_id])

    unless @user
      flash[:status] = :error
      flash[:message] = "You must be logged in to see this page"
      redirect_to login_path
      return
    end
  end
end
