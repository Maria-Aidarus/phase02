class Store < ApplicationRecord
    ## Relationships
    has_many :assignments
    has_many :employees, through: :assignments

    ## Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('name') }
end
