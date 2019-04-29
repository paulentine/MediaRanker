require "test_helper"

describe Work do
  before do
    @work = works(:album)
    @user = users(:zelda)
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
      @work.users << @user
      expect(@work.users.length).must_equal 1

      @work.users << users(:annie)
      expect(@work.users.length).must_equal 2
    end
  end

  describe "Featured" do
    it "Returns the highest-voted work" do
      # Upvote album (all other work has 0 upvote)
      @work.users << @user

      expect(Work.featured.category).must_equal @work.category
      expect(Work.featured.title).must_equal @work.title
      expect(Work.featured.creator).must_equal @work.creator
      expect(Work.featured.publication_year).must_equal @work.publication_year
      expect(Work.featured.description).must_equal @work.description
    end
  end

  describe "Top Ten" do
    it "Returns 10 works even if no vote has ever been casted" do
      expect(Work.top_ten("album").count).must_equal Work.where(category: "album").count
      expect(Work.top_ten("book").count).must_equal Work.where(category: "book").count
      expect(Work.top_ten("movie").count).must_equal Work.where(category: "movie").count
    end

    it "Returns all work if the category has less than 10 works" do
      @work.users << @user
      works(:book).users << @user
      works(:movie).users << users(:annie)

      expect(Work.top_ten("album").count).must_equal Work.where(category: "album").count
      expect(Work.top_ten("book").count).must_equal Work.where(category: "book").count
      expect(Work.top_ten("movie").count).must_equal Work.where(category: "movie").count
    end

    it "Returns top 10 highest-rated work for each category" do
      categories = ["album", "book", "movie"]
      titles = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]

      categories.each do |category|
        titles.each do |title|
          Work.create(
            category: category,
            title: title << category,
          )
        end
      end
      
      Work.count.must_equal 30

      # Add one vote for each fixture
      @work.users << @user
      works(:album).users << @user
      works(:movie).users << @user

      categories.each do |category|
        expect(Work.top_ten(category).first.category).must_equal Work.where(category: category).first.category
        expect(Work.top_ten(category).first.title).must_equal Work.where(category: category).first.title
        expect(Work.top_ten(category).first.creator).must_equal Work.where(category: category).first.creator
        expect(Work.top_ten(category).first.publication_year).must_equal Work.where(category: category).first.publication_year
        expect(Work.top_ten(category).first.description).must_equal Work.where(category: category).first.description
      end
    end
  end
end
