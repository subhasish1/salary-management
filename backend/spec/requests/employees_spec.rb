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
end
