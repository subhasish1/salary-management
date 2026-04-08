require 'rails_helper'

RSpec.describe "Employees API", type: :request do
  describe "GET /employees" do
    it "returns all employees" do
      employees = FactoryBot.create_list(:employee, 10)

      get "/employees"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(10)
    end

    it "returns employees with full_name" do
      employee = FactoryBot.create(:employee, first_name: "John", last_name: "Doe")
      FactoryBot.create_list(:employee, 9)

      get "/employees"

      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      john = parsed_body.find { |emp| emp["full_name"] == "John Doe" }
      expect(john["full_name"]).to eq("John Doe")
    end
  end

  describe "GET /employees/:id" do
    it "returns the employee with full_name" do
      employee = FactoryBot.create(:employee, first_name: "Jane", last_name: "Smith")

      get "/employees/#{employee.id}"

      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["full_name"]).to eq("Jane Smith")
    end

    it "returns 404 for non-existent employee" do
      get "/employees/99999"

      expect(response).to have_http_status(:not_found)
    end
  end


  describe "POST /employees" do
    it "creates a new employee" do
      employee_params = {
        first_name: "Alice",
        last_name: "Johnson",
        job_title: "Developer",
        country: "USA",
        salary: 80000
      }

      post "/employees", params: { employee: employee_params }

      expect(response).to have_http_status(:created)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["full_name"]).to eq("Alice Johnson")
      expect(parsed_body["job_title"]).to eq("Developer")
      expect(parsed_body["country"]).to eq("USA")
      expect(parsed_body["salary"]).to eq(80000)
    end

    it "returns errors for invalid employee" do
      post "/employees", params: { employee: { first_name: "", last_name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["errors"]).to include("First name can't be blank")
      expect(parsed_body["errors"]).to include("Last name can't be blank")
    end

    it "returns errors for invalid salary" do
      employee_params = {
        first_name: "Alice",
        last_name: "Johnson",
        job_title: "Developer",
        country: "USA",
        salary: -1
      }
      post "/employees", params: { employee: employee_params }

      expect(response).to have_http_status(:unprocessable_entity)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["errors"]).to include("Salary must be greater than 0")
    end
  end

  describe "PUT /employees/:id" do
    it "updates an existing employee" do
      employee = FactoryBot.create(:employee, first_name: "Bob", last_name: "Brown")

      update_params = {
        first_name: "Robert",
        last_name: "Brown",
        job_title: "Senior Developer",
        country: "USA",
        salary: 90000
      }

      put "/employees/#{employee.id}", params: { employee: update_params }

      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["full_name"]).to eq("Robert Brown")
      expect(parsed_body["job_title"]).to eq("Senior Developer")
      expect(parsed_body["country"]).to eq("USA")
      expect(parsed_body["salary"]).to eq(90000)
    end

    it "returns 404 for non-existent employee" do
      put "/employees/99999", params: { employee: { first_name: "Test" } }

      expect(response).to have_http_status(:not_found)
    end

    it "returns errors for invalid salary input" do
      employee = FactoryBot.create(:employee, first_name: "Bob", last_name: "Brown")

      put "/employees/#{employee.id}", params: { employee: { salary: -1 } }

      expect(response).to have_http_status(:unprocessable_entity)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["errors"]).to include("Salary must be greater than 0")
    end

    it "returns errors for invalid update, raise StandardError" do
      employee = FactoryBot.create(:employee, first_name: "Bob", last_name: "Brown")

      allow_any_instance_of(Employee).to receive(:update!).and_raise(StandardError, "Update failed")

      put "/employees/#{employee.id}", params: { employee: { first_name: "Test" } }

      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe "DELETE /employees/:id" do
    it "deletes an existing employee" do
      employee = FactoryBot.create(:employee)

      delete "/employees/#{employee.id}"

      expect(response).to have_http_status(:no_content)
      expect(Employee.find_by(id: employee.id)).to be_nil
    end

    it "returns 404 for non-existent employee" do
      delete "/employees/99999"

      expect(response).to have_http_status(:not_found)
    end
  end
end
