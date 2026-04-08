import { useEffect, useState } from 'react';
import { employeeAPI } from '../services/employeeAPI';
import '../styles/EmployeeForm.css';

export default function EmployeeForm({ employeeId, onSuccess, onCancel }) {
  const [formData, setFormData] = useState({
    first_name: '',
    last_name: '',
    job_title: '',
    country: '',
    salary: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const isEditing = !!employeeId;

  useEffect(() => {
    if (isEditing) {
      loadEmployee();
    }
  }, [employeeId]);

  async function loadEmployee() {
    try {
      const data = await employeeAPI.getEmployee(employeeId);
      setFormData({
        first_name: data.first_name || '',
        last_name: data.last_name || '',
        job_title: data.job_title,
        country: data.country,
        salary: data.salary,
      });
    } catch (err) {
      setError(err.message);
    }
  }

  function handleChange(e) {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      if (isEditing) {
        await employeeAPI.updateEmployee(employeeId, formData);
      } else {
        await employeeAPI.createEmployee(formData);
      }
      onSuccess();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="employee-form">
      <h2>{isEditing ? 'Edit Employee' : 'Add New Employee'}</h2>
      {error && <div className="error-message">{error}</div>}

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="first_name">First Name *</label>
          <input
            type="text"
            id="first_name"
            name="first_name"
            value={formData.first_name}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="last_name">Last Name *</label>
          <input
            type="text"
            id="last_name"
            name="last_name"
            value={formData.last_name}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="job_title">Job Title *</label>
          <input
            type="text"
            id="job_title"
            name="job_title"
            value={formData.job_title}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="country">Country *</label>
          <input
            type="text"
            id="country"
            name="country"
            value={formData.country}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="salary">Salary *</label>
          <input
            type="number"
            id="salary"
            name="salary"
            value={formData.salary}
            onChange={handleChange}
            min="1"
            required
          />
        </div>

        <div className="form-actions">
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? 'Saving...' : isEditing ? 'Update' : 'Add Employee'}
          </button>
          <button type="button" className="btn btn-secondary" onClick={onCancel}>
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
