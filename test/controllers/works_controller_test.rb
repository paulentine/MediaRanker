require "test_helper"

describe WorksController do
  before do
    @work = Work.create!(category: "album", title: "test work", creator: "me", publication_year: 2019, description: "something something")
  end
  describe "index" do
    it "renders without crashing" do
      # Arrange

      # Act
      get works_path

      # Assert
      must_respond_with :ok
    end

    it "renders even if there are zero work" do
      # Arrange
      Work.destroy_all

      # Act
      get works_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "show" do
    it "returns a 404 status code if the work doesn't exist" do
      # TODO come back to this
      work_id = 1337

      get work_path(work_id)

      must_respond_with :not_found
    end

    it "works for a work that exists" do
      # Arrange: set up a book
      # See before block above

      # Act: Hey server, can you find the book
      # that we just made
      get work_path(@work.id)

      # Assert
      must_respond_with :ok
    end
  end

  describe "new" do
    it "returns status code 200" do
      get new_work_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new work" do
      # Arrange
      work_data = {
        work: {
          category: "movie",
          title: "test movie",
          creator: "me",
          publication_year: 2019,
          description: "something",
        },
      }

      # Act
      expect {
        post works_path, params: work_data
      }.must_change "Work.count", +1

      # before_book_count = Book.count
      # post books_path, params: book_data
      # expect(Book.count).must_equal before_book_count + 1

      # Assert
      must_respond_with :redirect
      must_redirect_to works_path

      check_flash


      new_work = Work.last

      expect(new_work.category).must_equal work_data[:work][:category]
      expect(new_work.title).must_equal work_data[:work][:title]
      expect(new_work.creator).must_equal work_data[:work][:creator]
      expect(new_work.publication_year).must_equal work_data[:work][:publication_year]
      expect(new_work.description).must_equal work_data[:work][:description]
    end

    it "sends back bad_request if no work data is sent" do
      work_data = {
        work: {
          title: "",
        },
      }
      expect(Work.new(work_data[:work])).wont_be :valid?

      # Act
      expect {
        post works_path, params: work_data
      }.wont_change "Work.count"

      # Assert
      must_respond_with :bad_request

      check_flash(:error)
    end
  end

  describe "edit" do
    it "responds with OK for a real work" do
      get edit_work_path(@work)
      must_respond_with :ok
    end

    it "responds with NOT FOUND for a fake work" do
      work_id = Work.last.id + 1
      get edit_work_path(work_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:work_data) {
      {
        work: {
          title: "changed",
        },
      }
    }
    it "changes the data on the model" do
      # Assumptions
      @work.assign_attributes(work_data[:work])
      expect(@work).must_be :valid?
      @work.reload

      # Act
      patch work_path(@work), params: work_data

      # Assert
      must_respond_with :redirect
      must_redirect_to work_path(@work)

      check_flash

      @work.reload
      expect(@work.title).must_equal(work_data[:work][:title])
    end

    it "responds with NOT FOUND for a fake work" do
      work_id = Work.last.id + 1
      patch work_path(work_id), params: work_data
      must_respond_with :not_found
    end

    it "responds with BAD REQUEST for bad data" do
      # Arrange
      work_data[:work][:title] = ""

      # Assumptions
      @work.assign_attributes(work_data[:work])
      expect(@work).wont_be :valid?
      @work.reload

      # Act
      patch work_path(@work), params: work_data

      # Assert
      must_respond_with :bad_request

      check_flash(:error)
    end
  end

  describe "destroy" do
    it "removes the work from the database" do
      # Act
      expect {
        delete work_path(@work)
      }.wont_change "Work.count"

      # Assert
      must_respond_with :redirect
      must_redirect_to works_path

      @work.reload

      @work.deleted.must_equal true
    end

    it "returns a 404 if the book does not exist" do
      # Arrange
      work_id = 123456

      # Assumptions
      expect(Work.find_by(id: work_id)).must_be_nil

      # Act
      expect {
        delete work_path(work_id)
      }.wont_change "Work.count"

      # Assert
      must_respond_with :not_found
    end
  end
end