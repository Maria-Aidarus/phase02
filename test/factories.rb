FactoryBot.define do
    # Store
    factory :store do
        name { "Starbucks" }
        street { "The Street One" }
        city { "Pittsburgh" }
        state { "PA" }
        zip { "12345" }
        phone { "947-229-0129" }
        active { true }
    end

    # Employee
    factory :employee do
        first_name { "Maria" }
        last_name { "Aidarus" }
        ssn { "097328462" }
        date_of_birth { "2002-03-05" }
        phone { "243-654-2345" }
        role { 3 }
        active { true }
    end

    # Assignment
    factory :assignment do
        association :store
        association :employee
        start_date { "2023-02-11" }
        end_date { "2023-02-12" }
    end
end