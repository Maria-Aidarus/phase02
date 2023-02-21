require "test_helper"

describe Assignment do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships
  should belong_to(:store)
  should belong_to(:employee)

  # Validations 
  should validate_presence_of(:start_date)

  # validating date
  should allow_value(Date.current).for(:start_date)
  should allow_value(1.day.ago.to_date).for(:start_date)
  should allow_value(1.year.ago.to_date).for(:start_date)
  should allow_value(30.day.ago.to_date).for(:start_date)
  should allow_value(3.year.ago.to_date).for(:start_date)
  should allow_value(nil).for(:end_date)

  should_not allow_value(1.day.from_now.to_date).for(:start_date)
  should_not allow_value("text").for(:start_date)
  should_not allow_value(2).for(:start_date)
  should_not allow_value(3.14159).for(:start_date) 
  should_not allow_value(nil).for(:start_date)

  # Creating Contexts
  context "Creating an Assignment Context" do
    # creates associated records from the given model
    setup do
      create_stores
      create_employees
      create_assignments
    end

    # deletes associated records from the given model
    teardown do
      destroy_assignments
      destroy_employees
      destroy_stores
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

    should "show that make_active method works" do
      @flat_white.make_active
      assert_equal true, @flat_white.active
    end

    should "show that make_inactive method works" do
      @cmu_cafe.make_inactive
      assert_equal false, @cmu_cafe.active
    end

    should "show that the CMU Cafe's phone number was stripped of non-digits" do
      assert_equal "7628272973", @cmu_cafe.phone
    end
    
    should "show that the make_active method works" do
      @may.make_active
      assert_equal true, @may.active
    end

    should "show that the make_inactive method works" do
      @huda.make_inactive
      assert_equal false, @huda.active
    end

    should "show that the name method works" do 
      assert_equal "Aidarus Maria", @maria.name
    end

    should "show that the proper_name method works" do
      assert_equal "Huda Joad", @huda.proper_name
    end

    should "show that the current_assignment method works" do
      assert_nil @huda.current_assignment
      #assert_equal @maria.current_assignment, @maria_assignment_two
    end
    
    should "show that the end_current_assignment method works" do
      # Create a new store, employee, and two assignments
      @temp_cafe = FactoryBot.create(:store, name: 'Cafe Temp')
      @aisha = FactoryBot.create(:employee, first_name: 'Aisha', last_name: 'Al-Khaldi', ssn: '986201864')
      @aisha_assignment = FactoryBot.create(:assignment, employee: @aisha, store: @flat_white, start_date: '2022-08-06', end_date: nil)
      @aisha_assignment_two = FactoryBot.create(:assignment, employee: @aisha, store: @flat_white, start_date: '2023-02-21', end_date: nil)
      @aisha_assignment.reload
      # check for equality
      assert_equal @aisha_assignment.end_date, @aisha_assignment_two.start_date
      # Destroy all new objects
      @aisha_assignment.delete
      @aisha_assignment_two.delete
      @aisha.delete
      @temp_cafe.delete
    end

    should "show that the over_18? method works" do 
      assert_equal true, @maria.over_18?
      #assert_equal false, @sara.over_18?
    end

  end

end
