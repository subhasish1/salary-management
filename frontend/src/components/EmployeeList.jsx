import { useEffect, useState } from 'react';
import { employeeAPI } from '../services/employeeAPI';
import '../styles/EmployeeList.css';

export default function EmployeeList({ onViewEmployee, onEditEmployee, onRefresh }) {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadEmployees();
  }, [onRefresh]);

  async function loadEmployees() {
    setLoading(true);
    setError('');
    try {
      const data = await employeeAPI.getAllEmployees();
      setEmployees(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id) {
    if (confirm('Are you sure you want to delete this employee?')) {
      try {
        await employeeAPI.deleteEmployee(id);
        loadEmployees();
      } catch (err) {
        setError(err.message);
      }
    }
  }

  if (loading) return <div className="loading">Loading employees...</div>;

  return (
    <div className="employee-list">
      <h2>Employees</h2>
      {error && <div className="error-message">{error}</div>}
      
      {employees.length === 0 ? (
        <p>No employees found</p>
      ) : (
        <table className="employees-table">
          <thead>
            <tr>
              <th>Full Name</th>
              <th>Job Title</th>
              <th>Country</th>
              <th>Salary</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {employees.map((employee) => (
              <tr key={employee.id}>
                <td>{employee.full_name}</td>
                <td>{employee.job_title}</td>
                <td>{employee.country}</td>
                <td>{employee.salary.toLocaleString()}</td>
                <td className="actions">
                  <button
                    className="btn btn-primary btn-sm"
                    onClick={() => onViewEmployee(employee.id)}
                  >
                    View
                  </button>
                  <button
                    className="btn btn-secondary btn-sm"
                    onClick={() => onEditEmployee(employee.id)}
                  >
                    Edit
                  </button>
                  <button
                    className="btn btn-danger btn-sm"
                    onClick={() => handleDelete(employee.id)}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
