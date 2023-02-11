class Store < ApplicationRecord
    # Relationships 
    has_many :assignments
    has_many :employees, through: :assignments

    ## Scopes
    # active employees
    scope :active, -> { where(active:true) }

    # inactive employees
    scope :inactive, -> { where.(active:false) }

    # orders employees in alphabetical order
    scope :alphabetical, -> { order('name') }

end
