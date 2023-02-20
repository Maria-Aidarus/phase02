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

  
end
