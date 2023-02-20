module Contexts
    # Stores
    def create_stores
        @starbucks = FactoryBot.create(:store)
        @coffee_beans = FactoryBot.create(:store, name: "Coffee Beans", street: "Street One", city: "City One", state: "PA", zip: "84383", phone: "434 342 4648", active: true)
        @cmu_cafe = FactoryBot.create(:store, name: "CMU Cafe", street: "Street Two", city: "City Two", state: "OH", zip: "43593", phone: "(762) 827.2973", active: true)
        @flat_white = FactoryBot.create(:store, name: "Flat White", street: "Cafe Street", city: "City Three", state: "WV", zip: "54832", phone: "123.673-9835", active: false)
    end

    def destroy_stores
        @starbucks.delete
        @coffee_beans.delete
        @cmu_cafe.delete
        @flat_white.delete
    end

    # Employees
    def create_employees
        @maria = FactoryBot.create(:employee, role: 3)
        @huda = FactoryBot.create(:employee, first_name: "Huda", last_name: "Joad", ssn: "329420134", date_of_birth: "2003-06-06", phone: "876.546.2354", role: 3, active: true)
        @maryam = FactoryBot.create(:employee, first_name: "Maryam", last_name: "Rahmatullah", ssn: "844982543", date_of_birth: "2002-12-11", phone: "564.111.2222", role: 2)
        @may = FactoryBot.create(:employee, first_name: "May", last_name: "Khin", ssn: "987-42-8523", date_of_birth: "2000-09-15", phone: "121.135.8763", role: 1, active: false)
        @sara = FactoryBot.create(:employee, first_name: "Sara", last_name: "Al-Saloos", ssn: "321-25-9743", date_of_birth: "2006-09-5", phone: "111-222-3333", role: 1, active: true)
    end

    def destroy_employees
        @maria.delete
        @huda.delete
        @maryam.delete
        @may.delete
        @sara.delete
    end

    # Assignments


end