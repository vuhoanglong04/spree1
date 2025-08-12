class Api::BaseController < ActionController::API
  include ResponseHandler
  include ExceptionHandler
  include JwtHelper
end
