class Employee < ApplicationRecord

    # Relationships 
    #------------------
    has_many :assignments
    has_many :stores, through: :assignments

    # Callbacks
    #------------------
    before_save :reformat_phone
    before_save :reformat_ssn

    # Validations
    #------------------
    # validating the presence of several fields
    validates_presence_of :first_name, :last_name, :phone, :ssn, :role, :date_of_birth
    # validating uniqueness of ssn
    validates_uniqueness_of :ssn
    # validating the phone number
    validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-. ]\d{4})\z/, message: "The Phone Number should be 10 digits long."
    # validating the ssn 
    validates_format_of :ssn, with: /\A(\d{9}|\(?\d{3}\)?[-. ]\d{2}[-. ]\d{4})\z/, message: "The ssn should be 9 digits long."
    # validating the age + date
    validates_date :date_of_birth
    validates :date_of_birth, comparison: {less_than_or_equal_to: 14.years.ago.to_date}
    # validating the roles
    validates :role, inclusion: [1, 2, 3, "employee", "manager", "admin"]

    # Scopes
    #------------------
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('last_name, first_name') }
    scope :is_18_or_older, -> { where('date_of_birth <= ?', 18.years.ago) }
    scope :younger_than_18, -> { where('date_of_birth > ?', 18.years.ago) }

    # roles | mapping
    enum :role, { employee: 1, manager: 2, admin: 3 }
    scope :regulars, -> { where(role: 1) }
    scope :managers, -> { where(role: 2) }
    scope :admins, -> { where(role: 3) }

    # Methods 
    #------------------
    def name
        # returns a string of the last_name, first_name
        self.last_name + ", " + self.first_name
    end 

    def proper_name
        # returns a string of the first_name last_name
        self.first_name + " " + self.last_name
    end

    def current_assignment
        # returns the employees current assignment
        self.assignments.current.first
    end

    # predicate method
    def over_18?
        # checks if the employee is over 18 or not
        self.date_of_birth < 18.years.ago.to_date 
    end

    def make_active 
        # updates the active role to true
        self.active = true
        # saves the value
        self.save!
    end

    def make_inactive
        # updates the active role to false
        self.active = false
        self.save!
    end

    # predicate method
    def employee_role?
        # checks if the employee is a regular employee
        self.role == 1 || self.role == "employee"
    end

    # predicate method
    def manager_role?
        # checks if the employee is a manager
        self.role == 2 || self.role == "manager"
    end

    # preidcate method
    def admin_role?
        # checks if the employee is an admin
        self.role == 3 || self.role == "admin"
    end

    # Private Methods
    #------------------
    private 
    def reformat_phone
        # changes the var to a string 
        phone = self.phone.to_s  
        # removes all of the non-digit values
        phone = phone.gsub(/[^0-9]/,"") 
        # creates new string stored with the phone number
        self.phone = phone       
    end

    def reformat_ssn
        # changes the var to a string 
        ssn = self.ssn.to_s 
        # removes all of the non-digit values
        ssn = ssn.gsub(/[^0-9]/,"") 
        # creates new string stored with the phone number
        self.ssn = ssn
    end

end