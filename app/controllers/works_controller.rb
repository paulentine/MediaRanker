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
      flash.now[:message = "Could not save work #{@work.id}"
      render :edit, status: :bad_request
    end
  end

  def destroy
    work.deleted = !work.deleted

    work.save

    redirect_to works_path
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
