class SalaryInsightsService
  def self.by_country(country)
    employees = Employee.where('LOWER(country) = ?', country.strip.downcase)

    return empty_response if employees.empty?

    {
      country: country.strip.upcase,
      min_salary: employees.minimum(:salary),
      max_salary: employees.maximum(:salary),
      avg_salary: employees.average(:salary).to_f.round(2),
      total_employees: employees.count
    }
  end

  def self.by_job_title(country:, job_title:)
    employees = Employee.where('LOWER(country) = ? AND LOWER(job_title) = ?', country.strip.downcase, job_title.strip.downcase)

    return empty_response if employees.empty?

    {
      country: country.strip.upcase,
      job_title: job_title.strip.titleize,
      avg_salary: employees.average(:salary).to_f.round(2),
      total_employees: employees.count
    }
  end

  def self.empty_response
    {
      message: "No data available"
    }
  end
end
