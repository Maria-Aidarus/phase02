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
  context "Creating a store context" do 
    setup do
      create_stores
    end

    teardown do
      destroy_stores
    end 

    # Test cases
    should "have a scope that alphabetizes the stores" do
      assert_equal ["CMU Cafe", "Coffee Beans", "Flat White", "Starbucks"], Store.alphabetical.map{|s| s.name}
    end

    should "have a scope that returns the active stores" do
      assert_equal ["CMU Cafe", "Coffee Beans", "Starbucks"], Store.active.alphabetical.map{|s| s.name}
    end

    should "have a scope that returns tha inactive stores" do
      assert_equal ["Flat White"], Store.inactive.alphabetical.map{|s| s.name}
    end

    should "show that make_active method works" do
      @flat_white.make_active
      assert_equal true, @flat_white.active
    end

    should "show that make inactive method works" do
      @cmu_cafe.make_inactive
      assert_equal false, @cmu_cafe.active
    end

    # Testing the private methods
    should "show that the CMU Cafe's phone number was stripped of non-digits" do
      assert_equal "7628272973", @cmu_cafe.phone
    end

  end


end
