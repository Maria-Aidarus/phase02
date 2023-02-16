class Store < ApplicationRecord
    ## Relationships
    #------------------
    has_many :assignments
    has_many :employees, through: :assignments

    ## Validations
    #------------------
    # validating the presence of several fields
    validates_presence _of :zip, :phone, :name, :street, :city, :state
    # validating the zip code
    validates_format_of :zip, with: /\A\d{5}\z/, message: "The Zip Code should be 5 digits long."
    # validating th phone number
    validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "The Phone Number should be 10 digits long."
    # validating the store name, must be unique

    # validating the states 
    validates_inclusion_of :state, in: %w[PA OH WV], message: "State can be either: PA, OH, WV."
    

    ## Scopes
    #------------------
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('name') }

    ## Methods
    #------------------
    def make_active 
        self.active = true
        self.save!
    end

    def make_inactive
        self.active = false
        self.save!
    end

end