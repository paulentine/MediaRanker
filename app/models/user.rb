

class User < ApplicationRecord
  has_and_belongs_to_many :works

  validates :username, uniqueness: true


  def upvote
    @user = User.find_by(username: username)
    @work = Work.find_by(id: params[:id])
    @user.works << @work
    flash[:status] = :success
    flash[:message] = "Successfully upvoted"
  end
end