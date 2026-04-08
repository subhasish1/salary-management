require 'rails_helper'

RSpec.describe EmployeePresenter, type: :presenter do
  let(:employee) { FactoryBot.build(:employee, first_name: 'John', last_name: 'Doe') }
  let(:presenter) { EmployeePresenter.new(employee) }

  describe '#full_name' do
    it 'returns concatenated first and last name' do
      expect(presenter.full_name).to eq('John Doe')
    end

    it 'handles single names' do
      employee.first_name = 'Madonna'
      employee.last_name = ''
      expect(presenter.full_name).to eq('Madonna ')
    end
  end

  describe '#to_h' do
    it 'returns a hash with full_name and employee attributes' do
      hash = presenter.to_h
      
      expect(hash[:full_name]).to eq('John Doe')
      expect(hash[:first_name]).to eq(employee.first_name)
      expect(hash[:last_name]).to eq(employee.last_name)
      expect(hash[:job_title]).to eq(employee.job_title)
      expect(hash[:country]).to eq(employee.country)
      expect(hash[:salary]).to eq(employee.salary)
      expect(hash[:email]).to eq(employee.email)
    end
  end
end
