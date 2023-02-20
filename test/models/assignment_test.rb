require "test_helper"

describe Assignment do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships
  should belong_to(:store)
  should belong_to(:employee)

  # # Validations 
  # should validate_presence_of(:start_date)

  # # validating date
  # should allow_value(Date.current).for(:start_date)
  # should allow_value(1.day.ago.to_date).for(:start_date)
  # should allow_value(1.year.ago.to_date).for(:start_date)
  # should allow_value(30.day.ago.to_date).for(:start_date)
  # should allow_value(3.year.ago.to_date).for(:start_date)
  # should allow_value(nil).for(:end_date)

  # should_not allow_value(1.day.from_now.to_date).for(:start_date)
  # should_not allow_value("text").for(:start_date)
  # should_not allow_value(2).for(:start_date)
  # should_not allow_value(3.14159).for(:start_date) 
  # should_not allow_value(nil).for(:start_date)

  # Creating Contexts
  context "Creating an Assignment Context" do
    # creates associated records from the given model
    setup do
      create_stores
      create_employees
      create_assignments
    end

    # destroys associated records from the given model
    teardown do
      create_stores
      create_employees
      create_assignments
    end

    should "have a scope that orders assignments by the store" do
      assert_equal [3, 4, 2, 1, 5, 6], Assignment.by_store.map{|a| a.id}
    end

    should "have a scope that returns current assignments" do
      assert_equal [3, 4, 5, 6], Assignment.current.by_store.map{|a| a.id}
    end

    should "have a scope that returns all past assignments" do
      assert_equal [2, 1], Assignment.past.by_store.map{|a| a.id}
    end

    should "have a scope that returns all the assignments ordered by employee" do
      assert_equal [1, 6, 5, 2, 4, 3], Assignment.by_employee.map{|a| a.id}
    end

    should "have a scope that returns all the assignments ordered chronologically" do
      assert_equal [4, 5, 3, 6, 1, 2], Assignment.chronological.map{|a| a.id}
    end

    should "have a scope that returns all the assignments for store: Starbucks" do
      assert_equal [1, 6, 5], Assignment.for_store(@starbucks).by_employee.map{|a| a.id}
    end

    should "have a scope that returns all the assignments for a specific employee: Maria Aidarus" do
      assert_equal [1, 6], Assignment.for_employee(@maria).by_store.map{|a| a.id}
    end

    should "have a scope that returns all the assignments for regular employees" do
      assert_equal [4, 5], Assignment.for_role("employee").by_store.map{|a| a.id}
    end

    should "have a scope that returns all the assignments for date 2022-01-01" do
      assert_equal [2, 1], Assignment.for_date("2022-01-01").by_store.map{|a| a.id}
    end
  end
end
