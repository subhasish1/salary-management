require 'rails_helper'

RSpec.describe SalaryInsightsService, type: :service do
  describe '.by_country' do
    context 'with employees in a country' do
      before do
        FactoryBot.create(:employee, country: 'USA', salary: 50_000)
        FactoryBot.create(:employee, country: 'USA', salary: 75_000)
        FactoryBot.create(:employee, country: 'USA', salary: 100_000)
        FactoryBot.create(:employee, country: 'Canada', salary: 60_000)
      end

      it 'returns minimum salary for the country' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats[:min_salary]).to eq(50_000)
      end

      it 'returns maximum salary for the country' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats[:max_salary]).to eq(100_000)
      end

      it 'returns average salary for the country' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats[:avg_salary]).to eq(75_000.0)
      end

      it 'returns employee count for the country' do
        stats = SalaryInsightsService.by_country('USa ')
        expect(stats[:total_employees]).to eq(3)
      end

      it 'includes the country name in uppercase' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats[:country]).to eq('USA')
      end

      it 'returns all stats in a hash' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats).to be_a(Hash)
        expect(stats.keys).to include(:country, :min_salary, :max_salary, :avg_salary, :total_employees)
      end

      it 'only includes employees from the specified country' do
        stats = SalaryInsightsService.by_country('USA')
        expect(stats[:total_employees]).to eq(3)
      end

      it 'is case-insensitive for country' do
        stats = SalaryInsightsService.by_country('usa')
        expect(stats[:total_employees]).to eq(3)
        expect(stats[:country]).to eq('USA')
      end

      it 'handles mixed case for country' do
        stats = SalaryInsightsService.by_country('UsA')
        expect(stats[:min_salary]).to eq(50_000)
        expect(stats[:country]).to eq('USA')
      end
    end

    context 'with no employees in a country' do
      it 'returns empty response with message' do
        stats = SalaryInsightsService.by_country('NonExistentCountry')
        expect(stats).to eq({ message: "No data available" })
      end

      it 'does not include salary stats' do
        stats = SalaryInsightsService.by_country('NonExistentCountry')
        expect(stats.keys).to eq([:message])
      end
    end

    context 'with single employee in a country' do
      before do
        FactoryBot.create(:employee, country: 'UK', salary: 80_000)
      end

      it 'returns same value for min, max, and average' do
        stats = SalaryInsightsService.by_country('UK')
        expect(stats[:min_salary]).to eq(80_000)
        expect(stats[:max_salary]).to eq(80_000)
        expect(stats[:avg_salary]).to eq(80_000.0)
        expect(stats[:total_employees]).to eq(1)
      end
    end
  end

  describe '.by_job_title' do
    before do
      FactoryBot.create(:employee, country: 'USA', job_title: 'Engineer', salary: 100_000)
      FactoryBot.create(:employee, country: 'USA', job_title: 'Engineer', salary: 120_000)
      FactoryBot.create(:employee, country: 'USA', job_title: 'Manager', salary: 150_000)
      FactoryBot.create(:employee, country: 'Canada', job_title: 'Engineer', salary: 90_000)
    end

    it 'returns average salary for a specific job title in a country' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'Engineer')
      expect(stats[:avg_salary]).to eq(110_000.0)
    end

    it 'returns employee count for the job title and country' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'Engineer')
      expect(stats[:total_employees]).to eq(2)
    end

    it 'only counts employees with matching job title and country' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'Manager')
      expect(stats[:avg_salary]).to eq(150_000.0)
      expect(stats[:total_employees]).to eq(1)
    end

    it 'does not include employees from other countries' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'Engineer')
      expect(stats[:total_employees]).to eq(2)
    end

    it 'includes country and job title in response' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'Engineer')
      expect(stats[:country]).to eq('USA')
      expect(stats[:job_title]).to eq('Engineer')
    end

    it 'rounds average to 2 decimal places' do
      FactoryBot.create(:employee, country: 'France', job_title: 'Consultant', salary: 50_000)
      FactoryBot.create(:employee, country: 'France', job_title: 'Consultant', salary: 50_001)
      
      stats = SalaryInsightsService.by_job_title(country: 'France', job_title: 'Consultant')
      expect(stats[:avg_salary]).to eq(50_000.5)
    end

    it 'is case-insensitive for country' do
      stats = SalaryInsightsService.by_job_title(country: 'usa', job_title: 'Engineer')
      expect(stats[:total_employees]).to eq(2)
      expect(stats[:country]).to eq('USA')
    end

    it 'is case-insensitive for job title' do
      stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'engineer')
      expect(stats[:avg_salary]).to eq(110_000.0)
      expect(stats[:job_title]).to eq('Engineer')
    end

    it 'handles mixed case for both country and job title' do
      stats = SalaryInsightsService.by_job_title(country: 'UsA', job_title: 'ENGINEER')
      expect(stats[:total_employees]).to eq(2)
      expect(stats[:avg_salary]).to eq(110_000.0)
      expect(stats[:country]).to eq('USA')
      expect(stats[:job_title]).to eq('Engineer')
    end

    context 'with no employees matching criteria' do
      it 'returns empty response with message' do
        stats = SalaryInsightsService.by_job_title(country: 'USA', job_title: 'NonExistentRole')
        expect(stats).to eq({ message: "No data available" })
      end

      it 'does not include salary or count stats' do
        stats = SalaryInsightsService.by_job_title(country: 'NonExistent', job_title: 'Engineer')
        expect(stats.keys).to eq([:message])
      end
    end
  end
end
