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
  validates_presence_of :start_date, :store_id, :employee_id
  validates_date :start_date
  validates :start_date, comparison: {less_than_or_equal_to: Date.current }
  validates_date :end_date, after: :start_date, on_or_before: lambda{Date.current}, allow_blank: true
  validate :store_active
  validate :employee_active

  # Scopes
  #------------------
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
  def store_active
    active_store_ids = Store.active.all.map{|s| s.id}
    unless active_store_ids.include?(self.store_id)
      errors.add(:store, "is not an active store.")
    end
  end

  def employee_active
    active_employee_ids = Employee.active.all.map{|e| e.id}
    unless active_employee_ids.include?(self.employee_id)
      errors.add(:employee, "is not an active employee.")
    end
  end

  def end_current_assignment
    # check if the end date != nil
    if employee.current_assignment != nil
      employee.current_assignment.update(end_date: start_date)
    end
  end

end