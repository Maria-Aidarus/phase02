FactoryBot.define do
  factory :employee do
    first_name { "MyString" }
    last_name { "MyString" }
    ssn { "MyString" }
    date_of_birth { "2023-02-07" }
    phone { 1 }
    role { "MyString" }
    active { false }
  end
end
