class EmployeesController < ApplicationController
    def index
        @employees = Employee.all
        render json: @employees.map { |employee| EmployeePresenter.new(employee).to_h }
    end

    def show
        @employee = Employee.find_by(id: params[:id])
        if @employee
            render json: EmployeePresenter.new(@employee).to_h
        else
            render json: { error: "Employee not found" }, status: :not_found
        end
    end
end
