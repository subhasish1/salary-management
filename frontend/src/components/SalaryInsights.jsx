import React, { useState } from 'react';
import { salaryInsightsAPI } from '../services/employeeAPI';
import '../styles/SalaryInsights.css';

export default function SalaryInsights({ onBack }) {
  const [selectedCountry, setSelectedCountry] = useState('');
  const [selectedJobTitle, setSelectedJobTitle] = useState('');
  const [countryStats, setCountryStats] = useState(null);
  const [jobTitleStats, setJobTitleStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleGetCountryStats = async (e) => {
    e.preventDefault();
    if (!selectedCountry.trim()) {
      setError('Please enter a country');
      return;
    }

    setLoading(true);
    setError('');
    setCountryStats(null);

    try {
      const data = await salaryInsightsAPI.getSalaryByCountry(selectedCountry);
      setCountryStats(data);
    } catch (err) {
      setError(err.message || 'Failed to fetch country salary insights');
    } finally {
      setLoading(false);
    }
  };

  const handleGetJobTitleStats = async (e) => {
    e.preventDefault();
    if (!selectedCountry.trim() || !selectedJobTitle.trim()) {
      setError('Please enter both country and job title');
      return;
    }

    setLoading(true);
    setError('');
    setJobTitleStats(null);

    try {
      const data = await salaryInsightsAPI.getSalaryByJobTitle(selectedCountry, selectedJobTitle);
      setJobTitleStats(data);
    } catch (err) {
      setError(err.message || 'Failed to fetch job title salary insights');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="salary-insights-container">
      <div className="insights-header">
        <h1>Salary Insights</h1>
        <button className="back-btn" onClick={onBack}>← Back</button>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="insights-grid">
        {/* Country Salary Statistics */}
        <div className="insights-section">
          <h2>By Country</h2>
          <form onSubmit={handleGetCountryStats} className="insights-form">
            <div className="form-group">
              <label htmlFor="country-input">Country:</label>
              <input
                id="country-input"
                type="text"
                value={selectedCountry}
                onChange={(e) => setSelectedCountry(e.target.value)}
                placeholder="e.g., USA, India, Canada"
              />
            </div>
            <button type="submit" disabled={loading}>
              {loading ? 'Loading...' : 'Get Stats'}
            </button>
          </form>

          {countryStats && (
            <>
              {countryStats.message ? (
                <div className="info-message">{countryStats.message}</div>
              ) : (
                <div className="stats-cards">
                  <div className="stat-card">
                    <div className="stat-label">Country</div>
                    <div className="stat-value">{countryStats.country}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Min Salary</div>
                    <div className="stat-value">{Number(countryStats.min_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Max Salary</div>
                    <div className="stat-value">{Number(countryStats.max_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Average Salary</div>
                    <div className="stat-value">{Number(countryStats.avg_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Total Employees</div>
                    <div className="stat-value">{countryStats.total_employees}</div>
                  </div>
                </div>
              )}
            </>
          )}
        </div>

        {/* Job Title Salary Statistics */}
        <div className="insights-section">
          <h2>By Job Title</h2>
          <form onSubmit={handleGetJobTitleStats} className="insights-form">
            <div className="form-group">
              <label htmlFor="country-input-2">Country:</label>
              <input
                id="country-input-2"
                type="text"
                value={selectedCountry}
                onChange={(e) => setSelectedCountry(e.target.value)}
                placeholder="e.g., USA, India, Canada"
              />
            </div>
            <div className="form-group">
              <label htmlFor="job-title-input">Job Title:</label>
              <input
                id="job-title-input"
                type="text"
                value={selectedJobTitle}
                onChange={(e) => setSelectedJobTitle(e.target.value)}
                placeholder="e.g., Software Engineer, Manager"
              />
            </div>
            <button type="submit" disabled={loading}>
              {loading ? 'Loading...' : 'Get Stats'}
            </button>
          </form>

          {jobTitleStats && (
            <>
              {jobTitleStats.message ? (
                <div className="info-message">{jobTitleStats.message}</div>
              ) : (
                <div className="stats-cards">
                  <div className="stat-card">
                    <div className="stat-label">Country</div>
                    <div className="stat-value">{jobTitleStats.country}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Job Title</div>
                    <div className="stat-value">{jobTitleStats.job_title}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Min Salary</div>
                    <div className="stat-value">{Number(jobTitleStats.min_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Max Salary</div>
                    <div className="stat-value">{Number(jobTitleStats.max_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Average Salary</div>
                    <div className="stat-value">{Number(jobTitleStats.avg_salary).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
                  </div>
                  <div className="stat-card">
                    <div className="stat-label">Total Employees</div>
                    <div className="stat-value">{jobTitleStats.total_employees}</div>
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
