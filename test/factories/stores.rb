FactoryBot.define do
  factory :store do
    name { "MyString" }
    street { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { 1 }
    phone { 1 }
    active { false }
  end
end
