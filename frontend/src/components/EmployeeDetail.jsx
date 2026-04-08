import { useEffect, useState } from 'react';
import { employeeAPI } from '../services/employeeAPI';
import '../styles/EmployeeDetail.css';

export default function EmployeeDetail({ employeeId, onBack, onEdit }) {
  const [employee, setEmployee] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadEmployee();
  }, [employeeId]);

  async function loadEmployee() {
    setLoading(true);
    setError('');
    try {
      const data = await employeeAPI.getEmployee(employeeId);
      setEmployee(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  if (loading) return <div className="loading">Loading employee details...</div>;
  if (error) return <div className="error-message">{error}</div>;
  if (!employee) return <div className="error-message">Employee not found</div>;

  return (
    <div className="employee-detail">
      <div className="detail-header">
        <h2>{employee.full_name}</h2>
        <div className="detail-actions">
          <button className="btn btn-secondary" onClick={() => onEdit(employeeId)}>
            Edit
          </button>
          <button className="btn btn-secondary" onClick={onBack}>
            Back to List
          </button>
        </div>
      </div>

      <div className="detail-info">
        <div className="info-item">
          <label>Job Title:</label>
          <p>{employee.job_title}</p>
        </div>
        <div className="info-item">
          <label>Country:</label>
          <p>{employee.country}</p>
        </div>
        <div className="info-item">
          <label>Salary:</label>
          <p>{employee.salary.toLocaleString()}</p>
        </div>
      </div>
    </div>
  );
}
