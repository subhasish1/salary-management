FactoryBot.define do
  factory :employee do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    job_title { Faker::Job.title }
    country { Faker::Address.country }
    email { Faker::Internet.unique.email }
    salary { Faker::Number.between(from: 30_000, to: 200_000) }
  end
end
