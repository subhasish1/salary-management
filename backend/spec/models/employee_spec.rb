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

      it 'validates email presence' do
        employee.email = nil
        expect(employee).not_to be_valid
      end

      it 'validates email uniqueness' do
        FactoryBot.create(:employee, email: 'john.doe@example.com')
        duplicate_employee = FactoryBot.build(:employee, email: 'john.doe@example.com')
        expect(duplicate_employee).not_to be_valid
      end

        it 'strips whitespace from attributes' do
            employee.first_name = ' John '
            employee.last_name = ' Doe '
            employee.job_title = ' Developer '
            employee.country = ' USA '
            employee.email = 'john.doe@example.com'

            employee.save
            expect(employee.first_name).to eq('John')
            expect(employee.last_name).to eq('Doe')
            expect(employee.job_title).to eq('Developer')
            expect(employee.country).to eq('USA')
            expect(employee.email).to eq('john.doe@example.com')
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
