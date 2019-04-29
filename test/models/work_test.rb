require "test_helper"

describe Work do
  before do
    @work = works(:book)
  end

  describe "Validation" do
    it "Must be valid with good data" do
      result = @work.valid?

      expect(result).must_equal true
    end

    it "Raises an error when creating work without a title" do
      work = Work.new(
        title: nil,
      )
    end

    it "Raises an error if title is not unique" do
      # arrange
      duplicate_title = @work.title

      work = Work.new(
        title: duplicate_title,
      )

      # act
      result = work.valid?

      # assert
      expect(result).must_equal false
      expect(work.errors.messages).must_include :title
    end
  end

  describe "Relations" do
    it "Has votes (through relship with users)" do
      @work.users << users(:zelda)
      expect(@work.users.length).must_equal 1

      @work.users << users(:annie)
      expect(@work.users.length).must_equal 2
    end
  end

  describe "Featured" do
    it "Returns the highest-voted work" do

    end
  end

  describe "Top Ten" do
    it "Returns top 10 highest-rated work for each category" do

    end

    it "Returns all work if the category has less than 10 works" do

    end

    it "Returns 10 works even if no vote has ever been casted" do
    
    end

    it "Handles ties in number of votes" do

    end
  end
end
