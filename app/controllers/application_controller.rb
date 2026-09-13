class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :parse_error

  private

  def record_not_found
    render json: { errors: ["Record not found"] }, status: :not_found
  end

  def parse_error(exception)
    render json: { errors: ["Invalid request parameters. Please check your JSON format."] }, status: :bad_request
  end
end
