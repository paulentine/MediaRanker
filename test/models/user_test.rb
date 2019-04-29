require "test_helper"

describe User do
  before do
    @user = users(:zelda)
  end
  
  describe "Validation" do
    it "Must be valid with good data" do
      expect(@user).must_be :valid?
    end

    it "Raises an error when creating user without username" do
      user = User.new(
        username: nil,
      )
    end

    it "Raises an error if username is not unique" do
      # arrange
      duplicate_name = @user.username

      user = User.new(
        username: duplicate_name,
      )

      # act
      result = user.valid?

      # assert
      expect(result).must_equal false
      expect(user.errors.messages).must_include :username
    end
  end

  describe "Relations" do
    it "Has votes (through relship with works)" do
      @user.works << works(:album)
      expect(@user.works.length).must_equal 1

      @user.works << works(:book)
      expect(@user.works.length).must_equal 2

      @user.works << works(:movie)
      expect(@user.works.length).must_equal 3
    end
  end
end
