class EmployeesController < ApplicationController
  before_action :find_employee, only: [:show, :update, :destroy]

  def index
    @employees = Employee.all
    render json: @employees.map { |employee| EmployeePresenter.new(employee).to_h }
  end

  def show
    render json: EmployeePresenter.new(@employee).to_h
  end

  def create
    @employee = Employee.new(employee_params)
    
    begin
      Employee.transaction do
        @employee.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    else
      render json: EmployeePresenter.new(@employee).to_h, status: :created
    end
  end

  def update
    begin
      Employee.transaction do
        @employee.update!(employee_params)
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    else
      render json: EmployeePresenter.new(@employee).to_h
    end
  end

  def destroy
    @employee.destroy
    head :no_content
  end

  private

  def find_employee
    @employee = Employee.find_by(id: params[:id])
    render json: { error: "Employee not found" }, status: :not_found unless @employee
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :job_title, :country, :salary, :email)
  end
end
