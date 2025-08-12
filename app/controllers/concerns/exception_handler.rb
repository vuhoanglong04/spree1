# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_response(errors: e.record.errors.full_messages, status: :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_response(
        errors: e.message,
        message: 'Validation failed',
        status: :unprocessable_entity
      )
    end

    rescue_from StandardError do |e|
      render_response(errors: e.message, status: :internal_server_error)
    end

    rescue_from AuthenticationError do |e|
      render_response(errors: e.message, status: :unauthorized)
    end
  end
end
