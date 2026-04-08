require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    let(:employee) { FactoryBot.build(:employee) }

    describe 'presence validations' do
      it 'is valid with valid attributes' do
        expect(employee).to be_valid
      end
      
      it 'validates presence of first_name' do
        employee.first_name = nil
        expect(employee).not_to be_valid
      end

      it 'validates presence of last_name' do
        employee.last_name = nil
        expect(employee).not_to be_valid
      end

      it 'validates presence of job_title' do
        employee.job_title = nil
        expect(employee).not_to be_valid
      end

      it 'validates presence of country' do
        employee.country = nil
        expect(employee).not_to be_valid
      end

      it 'validates presence of salary' do
        employee.salary = nil
        expect(employee).not_to be_valid
      end
    end

    describe 'numericality validations' do
      it 'validates salary is greater than 0' do
        employee.salary = 0
        expect(employee).not_to be_valid
      end

      it 'validates salary is not negative' do
        employee.salary = -1000
        expect(employee).not_to be_valid
      end

      it 'is valid with positive salary' do
        employee.salary = 50000
        expect(employee).to be_valid
      end
    end
  end
end
