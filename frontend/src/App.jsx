import { useState } from 'react';
import './styles/App.css';
import EmployeeList from './components/EmployeeList';
import EmployeeForm from './components/EmployeeForm';
import EmployeeDetail from './components/EmployeeDetail';

function App() {
  const [view, setView] = useState('list'); // 'list', 'add', 'edit', 'view'
  const [selectedEmployeeId, setSelectedEmployeeId] = useState(null);
  const [refresh, setRefresh] = useState(0);

  function handleAddEmployee() {
    setView('add');
    setSelectedEmployeeId(null);
  }

  function handleViewEmployee(id) {
    setSelectedEmployeeId(id);
    setView('view');
  }

  function handleEditEmployee(id) {
    setSelectedEmployeeId(id);
    setView('edit');
  }

  function handleFormSuccess() {
    setView('list');
    setRefresh((prev) => prev + 1);
  }

  function handleBackToList() {
    setView('list');
    setSelectedEmployeeId(null);
  }

  return (
    <div className="App">
      <header className="app-header">
        <h1>Salary Management System</h1>
        {view !== 'add' && view !== 'edit' && (
          <button className="btn btn-primary" onClick={handleAddEmployee}>
            + Add Employee
          </button>
        )}
      </header>

      <main className="app-main">
        {view === 'list' && (
          <EmployeeList
            onViewEmployee={handleViewEmployee}
            onEditEmployee={handleEditEmployee}
            onRefresh={refresh}
          />
        )}
        {view === 'add' && (
          <EmployeeForm onSuccess={handleFormSuccess} onCancel={handleBackToList} />
        )}
        {view === 'edit' && selectedEmployeeId && (
          <EmployeeForm
            employeeId={selectedEmployeeId}
            onSuccess={handleFormSuccess}
            onCancel={handleBackToList}
          />
        )}
        {view === 'view' && selectedEmployeeId && (
          <EmployeeDetail
            employeeId={selectedEmployeeId}
            onBack={handleBackToList}
            onEdit={handleEditEmployee}
          />
        )}
      </main>
    </div>
  );
}

export default App;
