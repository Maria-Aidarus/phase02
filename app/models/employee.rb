class Employee < ApplicationRecord
    ## Relationships 
    has_many :assignments
    has_many :stores, through: :assignments

    ## Validations
    #------------------
    # validating the presence of several fields
    validates_presence _of :first_name, :last_name
    # validating uniqueness of ssn
    validates_uniqueness_of :ssn
    # validating the phone number
    validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "The Phone Number should be 10 digits long."
    # validating the ssn 
    validates_format_of :ssn, with: /\A(\d{9}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "The ssn should be 9 digits long."
    # validating the age
    validates_date :date_of_birth, before: 14.years.ago, before_message: "Employees have to be older than 14 years of age."
    # validating the roles 
    validates_inclusion_of :role, in: %w[employee manager admin], message: "You must be an Employee, Manager, or Admin."

    ## Scopes
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
    
end
