require "test_helper"

describe Store do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships 
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)

  # Validations
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zip)
  should validate_presence_of(:phone)
  should validate_uniqueness_of(:name).case_insensitive

  # validating zip
  should allow_value("12345").for(:zip)
  should allow_value("23431").for(:zip)
  should allow_value("15217").for(:zip)
  should allow_value("15090").for(:zip)

  should_not allow_value("text").for(:zip)
  should_not allow_value("1234").for(:zip)
  should_not allow_value("12h89").for(:zip)
  should_not allow_value("8921A").for(:zip)

  # validating state
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)

  should_not allow_value("hi").for(:state)
  should_not allow_value("CA").for(:state)
  should_not allow_value(100).for(:state)
  should_not allow_value(10).for(:state)

  # validating phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
    
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-TEX-TEEX").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)

  # Creating Contexts
  context "Creating a Store Context" do 
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
    should "have a scope that alphabetizes the stores" do
      assert_equal ["CMU Cafe", "Coffee Beans", "Flat White", "Starbucks"], Store.alphabetical.map{|s| s.name}
    end

    should "have a scope that returns the active stores" do
      assert_equal ["CMU Cafe", "Coffee Beans", "Starbucks"], Store.active.alphabetical.map{|s| s.name}
    end

    should "have a scope that returns the inactive stores" do
      assert_equal ["Flat White"], Store.inactive.alphabetical.map{|s| s.name}
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
      assert_equal @maria.current_assignment, @maria_assignment_two
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
      assert_equal false, @sara.over_18?
    end

  end

end
