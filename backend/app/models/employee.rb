class Employee < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :job_title, presence: true
    validates :country, presence: true
    validates :salary, presence: true, numericality: { greater_than: 0 }
end
