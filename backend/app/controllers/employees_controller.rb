class EmployeesController < ApplicationController
    def index
        @employees = Employee.all
        render json: @employees.map { |employee| EmployeePresenter.new(employee).to_h }
    end
end
