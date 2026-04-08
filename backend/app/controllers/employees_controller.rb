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

  def create
    @employee = Employee.new(employee_params)
    
    begin
      Employee.transaction do
        @employee.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      return
    end

    render json: EmployeePresenter.new(@employee).to_h, status: :created
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :job_title, :country, :salary)
  end
end
