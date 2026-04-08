const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000';

export const employeeAPI = {
  async getAllEmployees() {
    const response = await fetch(`${API_BASE_URL}/employees`);
    if (!response.ok) throw new Error('Failed to fetch employees');
    return response.json();
  },

  async getEmployee(id) {
    const response = await fetch(`${API_BASE_URL}/employees/${id}`);
    if (!response.ok) throw new Error('Employee not found');
    return response.json();
  },

  async createEmployee(data) {
    const response = await fetch(`${API_BASE_URL}/employees`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ employee: data }),
    });
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.errors?.join(', ') || 'Failed to create employee');
    }
    return response.json();
  },

  async updateEmployee(id, data) {
    const response = await fetch(`${API_BASE_URL}/employees/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ employee: data }),
    });
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.errors?.join(', ') || 'Failed to update employee');
    }
    return response.json();
  },

  async deleteEmployee(id) {
    const response = await fetch(`${API_BASE_URL}/employees/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) throw new Error('Failed to delete employee');
  },
};

export const salaryInsightsAPI = {
  async getSalaryByCountry(country) {
    const response = await fetch(`${API_BASE_URL}/salary_insights/by_country?country=${encodeURIComponent(country)}`);
    if (!response.ok) throw new Error('Failed to fetch salary insights');
    return response.json();
  },

  async getSalaryByJobTitle(country, jobTitle) {
    const params = new URLSearchParams({
      country: country,
      job_title: jobTitle,
    });
    const response = await fetch(`${API_BASE_URL}/salary_insights/by_job_title?${params}`);
    if (!response.ok) throw new Error('Failed to fetch salary insights');
    return response.json();
  },
};
