class Employee < ApplicationRecord
    # Relationships 
    has_many :assignments 
    has_many :store, through: :assignments 

    ## Scopes
    # active employees
    scope :active, -> { where(active:true) }

    # inactive employees
    scope :inactive, -> { where.not(active:true) }

    # orders employees in alphabetical order
    scope :alphabetical, -> { order('last_name, first_name') }

    # returns employees over the age of 18 | MAYBE
    scope :is_18_or_older, -> { where('date_of_birth <= ?', 18.years.ago.to_date)}

    # returns employees younger than 18 | MAYBE
    scope :younger_than_18, -> { where('date_of_birth > ?', 18.years.ago.to_date)}

    # regular employees 
    scope :regulars, -> { where(role: 1)}

    # managers
    scope :managers, -> { where(role: 2)}  

    # admins
    scope :admins, -> { where(role: 3) }
    
end
