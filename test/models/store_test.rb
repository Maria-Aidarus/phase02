require "test_helper"

describe Store do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # Relationships 
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)

  # Validations
  should validate_presence_of(:zip)
  should validate_presence_of(:phone)
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)

  # validating zip
  should allow_value("12345").for(:zip)
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



  

end
