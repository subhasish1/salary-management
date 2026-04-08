# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'

puts "🌱 Starting seed process..."

# Clear existing employees
Employee.delete_all
puts "✓ Cleared existing employees"

# Load first and last names
first_names_path = Rails.root.join("db/first_names.txt")
last_names_path = Rails.root.join("db/last_names.txt")

first_names = File.readlines(first_names_path).map(&:strip).reject(&:empty?)
last_names = File.readlines(last_names_path).map(&:strip).reject(&:empty?)

puts "✓ Loaded #{first_names.count} first names and #{last_names.count} last names"

JOB_TITLES = [
  "Software Engineer", "Senior Developer", "DevOps Engineer", "Data Scientist",
  "Product Manager", "UX Designer", "Frontend Developer", "Backend Developer",
  "Full Stack Developer", "QA Engineer", "Technical Lead", "Engineering Manager",
  "Solutions Architect", "Cloud Engineer", "Database Administrator", "Security Engineer",
  "Machine Learning Engineer", "Business Analyst", "Systems Engineer", "Scrum Master",
  "AI Engineer", "Mobile Developer", "Platform Engineer", "Site Reliability Engineer",
  "Network Engineer", "Systems Administrator", "IT Manager", "CTO"
].freeze

COUNTRIES = [
  "India", "USA", "Canada", "UK", "Australia", "Germany", "France", "Japan",
  "Singapore", "Netherlands", "Sweden", "Norway", "Switzerland", "Israel",
  "Brazil", "Mexico", "Spain", "Italy", "Poland", "South Korea", "Russia",
  "Ukraine", "Romania", "Czech Republic", "Portugal", "Ireland", "New Zealand",
  "Philippines", "Vietnam", "Thailand", "Indonesia", "Malaysia"
].freeze

TOTAL_EMPLOYEES = 10_000
BATCH_SIZE = 500

# Pre-generate all employee data
puts "📝 Generating #{TOTAL_EMPLOYEES} employee records..."

employees_data = []
email_counter = 0

TOTAL_EMPLOYEES.times do |index|
  first_name = first_names.sample.strip
  last_name = last_names.sample.strip
  
  employees_data << {
    first_name: first_name,
    last_name: last_name,
    email: "employee#{email_counter}@example.com",
    job_title: JOB_TITLES.sample,
    country: COUNTRIES.sample,
    salary: rand(30_000..250_000),
    created_at: Time.current,
    updated_at: Time.current
  }
  
  email_counter += 1
end

puts "✓ Generated all records"

# Bulk insert in batches for performance
puts "🚀 Inserting #{TOTAL_EMPLOYEES} employees in batches of #{BATCH_SIZE}..."

employees_data.each_slice(BATCH_SIZE) do |batch|
  Employee.insert_all(batch)
  puts "✓ Inserted #{[employees_data.index(batch[0]) + BATCH_SIZE, TOTAL_EMPLOYEES].min} / #{TOTAL_EMPLOYEES} employees"
end

puts "✅ Seed completed! Created #{Employee.count} employees"

