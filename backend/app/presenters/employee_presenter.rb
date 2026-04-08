class EmployeePresenter
  def initialize(employee)
    @employee = employee
  end

  def full_name
    [@employee.first_name, @employee.last_name].join(' ')
  end

  def to_h
    {
      id: @employee.id,
      full_name: full_name,
      job_title: @employee.job_title,
      country: @employee.country,
      salary: @employee.salary,
      email: @employee.email
    }
  end
end
