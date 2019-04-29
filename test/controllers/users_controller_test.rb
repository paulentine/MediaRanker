require "test_helper"

describe UsersController do
  before do
    @work = Work.first
    @user = User.first
  end

  describe "login" do
    it "Lets user log in" do
      perform_login

      expect(session[:user_id]).must_equal @user.id

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "Lets user log out" do
      perform_login
      post logout_path

      expect(session[:user_id]).must_be_nil

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "votes" do
    it "Lets logged in user vote" do
      perform_login
      expect(session[:user_id]).must_equal @user.id

      expect {
        post upvote_path(@work.id)
      }.must_change 'Work.find(@work.id).users.count', +1

      must_respond_with :redirect
      must_redirect_to work_path
    end

    it "Does not let non-logged-in user vote" do
      perform_login
      post logout_path
      expect(session[:user_id]).must_be_nil

      expect {
        post upvote_path(@work.id)
      }.wont_change 'Work.find(@work.id).users.count'

      check_flash(:error)

      must_redirect_to login_path
    end

    it "Allows 1 vote per work per user" do
      perform_login
      expect(session[:user_id]).must_equal @user.id

      # First vote
      expect {
        post upvote_path(@work.id)
      }.must_change 'Work.find(@work.id).users.count', +1

      must_respond_with :redirect
      must_redirect_to work_path

      # Attempted second vote
      expect {
        post upvote_path(@work.id)
      }.wont_change 'Work.find(@work.id).users.count'

      check_flash(:error)

      must_redirect_to work_path
    end

    it "Does not let non-logged-in users vote" do
      expect {
        post upvote_path(@work.id)
      }.wont_change 'Work.find(@work.id).users.count'

      must_redirect_to login_path
    end

    it "Casting vote on non-existant work will cause an flash error" do
      bad_work_id = 1337

      perform_login
      expect(session[:user_id]).must_equal @user.id

      # Won't add user's votes' count
      expect {
        post upvote_path(bad_work_id)
      }.wont_change 'User.find(@user.id).works.count'

      check_flash(:error)

      must_redirect_to root_path
    end
  end
end
