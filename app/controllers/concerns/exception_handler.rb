# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  extend ActiveSupport::Concern

  included do

    rescue_from AuthenticationError do |e|
      render_response(errors: e.message, status: :unauthorized)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_response(errors: e.message, status: :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_messages =
        if e.record
          e.record.errors.full_messages
        else
          [e.message]
        end
      render_response(
        errors: error_messages,
        message: 'Validation failed',
        status: :unprocessable_entity
      )
    end

    rescue_from ActiveModel::ValidationError do |e|
      render_response(message: "Validation failed", errors: e.model.errors.full_messages, status: :unprocessable_entity)
    end

    rescue_from JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError do
      render_response(message: "Unauthorized", status: :unauthorized)
    end
  end
end
