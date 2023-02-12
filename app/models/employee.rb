class Employee < ApplicationRecord
    ## Relationships 
    has_many :assignments
    has_many :stores, through: :assignments

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
