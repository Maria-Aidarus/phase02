class Store < ApplicationRecord

    # Relationships
    #------------------
    has_many :assignments
    has_many :employees, through: :assignments

    # Callback
    #------------------
    before_save :reformat_phone

    # Validations
    #------------------
    # validating the presence of several fields
    validates_presence_of :name, :street, :city, :state, :zip, :phone
    # validating uniqueness of store name
    validates_uniqueness_of :name, :case_sensitive => false
    # validating the zip code
    validates_format_of :zip, with: /\A\d{5}\z/, message: "The Zip Code should be 5 digits long."
    # validating the phone number
    validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-. ]\d{4})\z/, message: "The Phone Number should be 10 digits long."
    # validating the states 
    validates_inclusion_of :state, in: %w[PA OH WV], message: "State can be either: PA, OH, WV."

    # Scopes
    #------------------
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('name') }

    # Methods 
    #------------------
    def make_active 
        self.active = true
        self.save!
    end

    def make_inactive
        self.active = false
        self.save!
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
end