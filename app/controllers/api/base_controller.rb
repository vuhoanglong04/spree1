class Api::BaseController < ActionController::API
  include ResponseHandler
  include ExceptionHandler
end
