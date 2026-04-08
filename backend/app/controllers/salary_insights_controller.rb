class SalaryInsightsController < ApplicationController
  def by_country
    country = params[:country]
    
    if country.blank?
      render json: { error: 'Country parameter is required' }, status: :bad_request
      return
    end
    
    result = SalaryInsightsService.by_country(country)
    
    if result
      render json: result
    else
      render json: { error: 'No employees found for the specified country' }, status: :not_found
    end
  end

  def by_job_title
    country = params[:country]
    job_title = params[:job_title]
    
    if country.blank? || job_title.blank?
      render json: { error: 'Country and job_title parameters are required' }, status: :bad_request
      return
    end
    
    result = SalaryInsightsService.by_job_title(country:, job_title:)
    
    if result
      render json: result
    else
      render json: { error: 'No employees found for the specified country and job title' }, status: :not_found
    end
  end
end
