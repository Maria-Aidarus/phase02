require "test_helper"

describe Employee do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)

  # Validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:phone)
  should validate_presence_of(:ssn)
  should validate_presence_of(:role)
  should validate_uniqueness_of(:ssn)

  # validating phone
  should allow_value("999-999-9999").for(:phone)
  should allow_value("999.999.9999").for(:phone)
  should allow_value("(999) 999-9999").for(:phone)

  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)

  # validating ssn 
  should allow_value("999-99-9999").for(:ssn)
  should allow_value("999 99 9999").for(:ssn)
  should allow_value("999999999").for(:ssn)

  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("text").for(:ssn)
  should_not allow_value("text123").for(:ssn)

  # validating date of birth 
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(20.years.ago.to_date).for(:date_of_birth)

  should_not allow_value(13.years.ago.to_date).for(:date_of_birth)
  should_not allow_value("text").for(:date_of_birth)

  # validating roles
  should allow_value("employee").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("admin").for(:role)
  should allow_value(1).for(:role)
  should allow_value(2).for(:role)
  should allow_value(3).for(:role)

  #should_not allow_value("text").for(:role)
  should_not allow_value(nil).for(:role)

  # Creating Contexts
  context "Creating an Employee Context" do
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
    should "have a scope that alphabetizes all the employees" do
      assert_equal ["Maria", "Sara", "Huda", "May", "Maryam"], Employee.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all of the active employees" do
      assert_equal ["Maria", "Sara", "Huda", "Maryam"], Employee.active.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all of the inactive employees" do
      assert_equal ["May"], Employee.inactive.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all the employees that are 18 or older" do
      assert_equal ["Maria", "Huda", "May", "Maryam"], Employee.is_18_or_older.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all the employees that are younger than 18" do
      assert_equal ["Sara"], Employee.younger_than_18.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all of the regular employees" do
      assert_equal ["Sara", "May"], Employee.regulars.alphabetical.map{|e| e.first_name}
    end

    should "have have a scope that returns all of the manager employees" do
      assert_equal ["Maryam"], Employee.managers.alphabetical.map{|e| e.first_name}
    end

    should "have a scope that returns all of the admin employees" do
      assert_equal ["Maria", "Huda"], Employee.admins.alphabetical.map{|e| e.first_name}
    end 

    should "show that Sara's phone was stripped of non-digits" do
      assert_equal "1112223333", @sara.phone
    end

    should "show that May's ssn was stripped of non-digits" do
      assert_equal "987428523", @may.ssn
    end

    should "show that make_active method works" do
      @flat_white.make_active
      assert_equal true, @flat_white.active
    end

    should "show that make_inactive method works" do
      @cmu_cafe.make_inactive
      assert_equal false, @cmu_cafe.active
    end

  end
  
end
