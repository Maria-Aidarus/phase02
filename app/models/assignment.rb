class Assignment < ApplicationRecord
  # Relationships 
  #------------------
  belongs_to :store
  belongs_to :employee

  # Validations 
  #------------------
  # # validating store_id, employee_id
  # validates_presence_of :store_id
  # validates_presence_of :employee_id
  # validates_presence_of :start_date
  # # validating date
  # validates_date :start_date
  # validates :start_date, comparison: {less_than_or_equal_to: Date.current }
  # validates_date :end_date, allow_blank: true
  # validates :end_date, comparison: { greater_than: :start_date }, allow_blank: true


  # Scopes
  #------------------
  scope :current, -> { where(end_date: nil) }
  scope :past, -> { where.not(end_date: nil) }

  scope :by_store, -> { (joins(:store).order('name')) }
  scope :by_employee, -> { (joins(:employee).order('last_name', 'first_name')) }

  scope :chronological, -> { order('start_date DESC') }

  scope :for_store, ->(store) { where("store_id = ?", store.id) }
  scope :for_employee, ->(employee) { where("employee_id = ?", employee.id) }

  scope :for_role, ->(role) { joins(:employee).where("role = ?", Employee.roles[role]) }
  scope :for_date, ->(date) { where('start_date <= ? AND (end_date > ? OR end_date IS NULL)', date, date) }

end