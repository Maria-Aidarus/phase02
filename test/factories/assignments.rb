FactoryBot.define do
  factory :assignment do
    Store { nil }
    Employee { nil }
    start_date { "2023-02-07" }
    end_date { "2023-02-07" }
  end
end
