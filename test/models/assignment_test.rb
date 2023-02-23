require "test_helper"

describe Assignment do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships
  #------------------
  should belong_to(:store)
  should belong_to(:employee)

  # Validations 
  #------------------
  # validates the presence of the date 
  should validate_presence_of(:start_date)

  # validating the date
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
  context "Creating an Assignment Context:" do
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

    # Test cases
    #------------------
    # testing to see if the model can order assignments by the store
    should "have a scope that orders assignments by the store" do
      assert_equal [3, 1, 2, 4, 5], Assignment.by_store.map{|a| a.id}
    end

    # testing to see if the model can return the current assignments mapped by each store
    should "have a scope that returns current assignments by stores" do
      assert_equal [3, 4, 5], Assignment.current.by_store.map{|a| a.id}
    end

    # testing to see if the model can return the past assignments mapped by each store
    should "have a scope that returns all past assignments" do
      assert_equal [1, 2], Assignment.past.by_store.map{|a| a.id}
    end

    # testing to see if the model can return all the assignments ordered by employees
    should "have a scope that returns all the assignments ordered by employee" do
      assert_equal [1, 5, 4, 2, 3], Assignment.by_employee.map{|a| a.id}
    end

    # testing to see if the model can return all the assignments ordered chronologically 
    should "have a scope that returns all the assignments ordered chronologically" do
      assert_equal [4, 3, 5, 1, 2], Assignment.chronological.map{|a| a.id}
    end

    # testing to see if the model can return assignments for a certain store 
    should "have a scope that returns all the assignments for store: Starbucks" do
      assert_equal [1, 5, 4, 2], Assignment.for_store(@starbucks).by_employee.map{|a| a.id}
    end

    # testing to see if the model can return assignments for a certain employee
    should "have a scope that returns all the assignments for a specific employee: Maria Aidarus" do
      assert_equal [1, 5], Assignment.for_employee(@maria).by_store.map{|a| a.id}
    end

    # testing to see if the model can return assignments for all regular employees
    should "have a scope that returns all the assignments for regular employees" do
      assert_equal [4], Assignment.for_role("employee").by_store.map{|a| a.id}
    end

    # testing to see if the model can return all the assignment after a certain date
    should "have a scope that returns all the assignments for date 2022-01-01" do
      assert_equal [1, 2], Assignment.for_date("2022-01-01").by_store.map{|a| a.id}
    end
    
    # testing to see if the model can end a previous assignment when a new one is created
    should "show that the end_current_assignment method works" do
      # Create a new store, employee, and two assignments
      @temp_cafe = FactoryBot.create(:store, name: 'Cafe Temp')
      @aisha = FactoryBot.create(:employee, first_name: 'Aisha', last_name: 'Al-Khaldi', ssn: '986201864')
      @aisha_assignment = FactoryBot.create(:assignment, employee: @aisha, store: @starbucks, start_date: '2022-08-06', end_date: nil)
      @aisha_assignment_two = FactoryBot.create(:assignment, employee: @aisha, store: @starbucks, start_date: '2023-02-21', end_date: nil)
      @aisha_assignment.reload
      # check for equality
      assert_equal @aisha_assignment.end_date, @aisha_assignment_two.start_date
      # Destroy all new objects
      @aisha_assignment.delete
      @aisha_assignment_two.delete
      @aisha.delete
      @temp_cafe.delete
    end

    # testing to see if the predicate method works | checks if the emmployee is over 18
    should "show that the over_18? method works" do 
      assert_equal true, @maria.over_18?
      assert_equal false, @sara.over_18?
    end

    # testing to see if the predicate method works | checks if the employee is a regular employee
    should "show that the employer_role? method works" do 
      assert_equal false , @maria.employee_role?
      assert_equal true, @sara.employee_role?
    end

    # testing to see if the predicate method works | checks if the employee is a manager
    should "show that the manager_role? method works" do 
      assert_equal false , @may.manager_role?
      assert_equal true, @maryam.manager_role?
    end

    # testing to see if the predicate method works | checks if the employee is an admin
    should "show that the admin_role? method works" do 
      assert_equal true , @maria.admin_role?
    end

  end

end