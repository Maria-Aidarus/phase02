FactoryBot.define do
    
    # Store
    factory :store do
        name { "CMU Cafe" }
        street { "The Street One" }
        city { "Pittsburgh" }
        state { "PA" }
        zip { "12345" }
        phone { rand(10 ** 10).to_s.rjust(10,'0') }
        active true
    end

    # Employee
    factory :employee do
        first_name { "Maria" }
        last_name { "Aidarus" }
        ssn { "123456789" }
        date_of_birth { 20.years.ago.to_date }
        phone  { rand(10 ** 10).to_s.rjust(10,'0') }
        role { 3 }
        active true
    end

    # Assignment
    factory :assignment do
        association :store
        association :employee
        start_date { 2.years.ago.to_date }
        end_date { 1.years.ago.to_date }
    end


end