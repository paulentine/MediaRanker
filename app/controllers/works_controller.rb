class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]
  
  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    successful = @work.save
    if successful
      flash[:status] = :success
      flash[:message] = "Succesfully added work with ID #{@work.id}"
      redirect_to works_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not add work"
      render :new, status: :bad_request
    end
  end

  # Show and edit are entirely handled by find_work helper method

  def update
    if @work.update(work_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated work #{@work.id}"
      redirect_to work_path(@work)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save work #{@work.id}"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @work.deleted = !@work.deleted

    @work.save

    redirect_to works_path
  end


  def upvote
    @user = User.find_by(id: session[:user_id])
    unless @user
      flash[:status] = :error
      flash[:message] = "You must be logged in to upvote"
      redirect_to login_path
      return
    end

    @work = Work.find_by(id: params[:id])
    unless @work
      flash[:status] = :error
      flash[:message] = "That work does not exist"
      redirect_to root_path
      return
    end

    if @user.works.include?(@work)
      flash[:status] = :error
      flash[:message] = "You can only upvote each work once!"
      redirect_to work_path
    else
      @user.works << @work
      flash[:status] = :success
      flash[:message] = "Successfully upvoted #{@work}"
      redirect_to work_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description, user_id: [])
  end
    
  def find_work
    @work = Work.find_by(id: params[:id])
    unless @work
      head :not_found
      return
    end
  end

end
