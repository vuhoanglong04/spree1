# app/controllers/concerns/response_handler.rb
module ResponseHandler
  extend ActiveSupport::Concern

  def render_response(data: nil, message: nil, errors: nil, status: nil, meta: nil)
    http_status = status || default_status(errors)
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[http_status]

    response_body = {
      status_code: code,
      message: message || default_message(code),
      data: data,
      meta: meta
    }
    response_body[:errors] = Array(errors).map(&:to_s) if errors.present?
    render json: response_body.compact, status: http_status
  end

  private

  def default_message(code)
    Rack::Utils::HTTP_STATUS_CODES[code] || 'Unknown Status'
  end

  def default_status(errors)
    errors.present? ? :unprocessable_entity : :ok
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value,
      is_first_page: collection.first_page?,
      is_last_page: collection.last_page?
    }
  end
  def elasticsearch_pagination_meta(page, per_page, total_count)
    total_pages = (total_count / per_page.to_f).ceil

    {
      current_page: page,
      next_page: page < total_pages ? page + 1 : nil,
      prev_page: page > 1 ? page - 1 : nil,
      total_pages: total_pages,
      total_count: total_count,
      per_page: per_page,
      is_first_page: page == 1,
      is_last_page: page >= total_pages
    }
  end

end
