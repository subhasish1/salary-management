require 'rails_helper'

RSpec.describe "Employees API", type: :request do
  describe "GET /employees" do
    it "returns all employees" do
      employees = FactoryBot.create_list(:employee, 10)

      get "/employees"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(10)
    end

    it "returns employees with correct attributes" do
      employee = FactoryBot.create(:employee, first_name: "John")
      FactoryBot.create_list(:employee, 9)

      get "/employees"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["first_name"]).to eq("John")
    end
  end
end
