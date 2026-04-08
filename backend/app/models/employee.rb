class Employee < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :job_title, presence: true
    validates :country, presence: true
    validates :salary, presence: true, numericality: { greater_than: 0 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }

    %w[first_name last_name job_title country email].each do |attr|
        define_method("#{attr}=") do |value|
            super(value&.strip)
        end
    end
end
