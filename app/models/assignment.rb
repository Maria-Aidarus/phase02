class Assignment < ApplicationRecord

  # Relationships 
  #------------------
  belongs_to :store
  belongs_to :employee

  # Callbacks
  #------------------
  before_create :end_current_assignment

  # Validations 
  #------------------
  # validating the presence of: start_date, store_id, and employee_id
  validates_presence_of :start_date, :store_id, :employee_id
  # validating the date
  validates_date :start_date
  validates :start_date, comparison: {less_than_or_equal_to: Date.current }
  validates_date :end_date, after: :start_date, on_or_before: lambda{Date.current}, allow_blank: true
  # validating that the store is active
  validate :store_active
  validate :employee_active

  # Scopes
  #------------------
  # scopes for finding past/current assignments
  scope :current, -> { where(end_date: nil) }
  scope :past, -> { where.not(end_date: nil) }

  scope :by_store, -> { joins(:store).order('name') }
  scope :by_employee, -> { joins(:employee).order('last_name, first_name') }
  scope :chronological, -> { order('start_date DESC') }

  scope :for_store, ->(store) { where('store_id = ?', store.id) }
  scope :for_employee, ->(employee) { where('employee_id = ?', employee.id) }

  scope :for_role, ->(role) { joins(:employee).where('role = ?', Employee.roles[role]) }
  scope :for_date, ->(date) { where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', date, date) }

  # Private Methods
  #------------------
  private 
  # this method checks if the store is active for validations
  def store_active
    # maps all of the store id's that are active
    active_store_ids = Store.active.all.map{|s| s.id}
    # if the store id of the assignment is not there
    unless active_store_ids.include?(self.store_id)
      # error message 
      errors.add(:store, "is not an active store.")
    end
  end

  # this method checks if the employee is active for that particular assignment 
  def employee_active
    # maps all of the employee is active for validations
    active_employee_ids = Employee.active.all.map{|e| e.id}
    # if the employee id of the assignment is not there 
    unless active_employee_ids.include?(self.employee_id)
      # error message 
      errors.add(:employee, "is not an active employee.")
    end
  end

  # this method ends the previous assignment if a new one is created 
  def end_current_assignment
    # check if the end date != nil
    if employee.current_assignment != nil
      # updates the end date to the start date of the new assignment 
      employee.current_assignment.update(end_date: start_date)
    end
  end

end