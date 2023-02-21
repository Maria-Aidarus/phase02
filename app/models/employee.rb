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

    def make_active 
        self.active = true
        self.save!
    end

    def make_inactive
        self.active = false
        self.save!
    end

    # roles | mapping
    enum :role, { employee: 1, manager: 2, admin: 3 }
    scope :regulars, -> { where(role: 1) }
    scope :managers, -> { where(role: 2) }
    scope :admins, -> { where(role: 3) }

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
