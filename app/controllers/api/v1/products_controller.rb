class Api::V1::ProductsController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index, :show]

  def index
    page = (params[:page] || 1).to_i
    per_page = 100

    # Optional filters
    category_id = params[:category_id]
    search_name = params[:search_name]
    min_price = params[:min_price]
    max_price = params[:max_price]
    color_ids = params[:color_ids]&.map(&:to_i)
    size_ids = params[:size_ids]&.map(&:to_i)
    sort_order = params[:sorted] || "asc"

    # Build Elasticsearch query
    query = {
      bool: {
        must: [],
        filter: []
      }
    }

    # Filter by category
    query[:bool][:filter] << { term: { category_id: category_id.to_i } } if category_id.present?

    # Filter by product name (full-text match)
    if search_name.present?
      query[:bool][:must] << {
        query_string: {
          default_field: "name",
          query: "*#{search_name}*"
        }
      }
    end

    # Filter by nested product_variants.price
    if min_price || max_price
      range_filter = {}
      range_filter[:gte] = min_price.to_f if min_price
      range_filter[:lte] = max_price.to_f if max_price

      query[:bool][:filter] << {
        nested: {
          path: "product_variants",
          query: { range: { "product_variants.price": range_filter } }
        }
      }
    end
    # Filter by nested color_ids or size_ids
    if color_ids&.any? || size_ids&.any?
      variant_should = []

      # Nested color filter inside product_variants
      if color_ids&.any?
        variant_should << {
          nested: {
            path: "product_variants.color",
            query: {
              terms: { "product_variants.color.id": color_ids.map(&:to_i) }
            },
            score_mode: "max"
          }
        }
      end

      # Nested size filter inside product_variants
      if size_ids&.any?
        variant_should << {
          nested: {
            path: "product_variants.size",
            query: {
              terms: { "product_variants.size.id": size_ids.map(&:to_i) }
            },
            score_mode: "max"
          }
        }
      end

      # Wrap in a product_variants nested query
      query[:bool][:filter] << {
        nested: {
          path: "product_variants",
          query: {
            bool: {
              should: variant_should,
              minimum_should_match: 1
            }
          },
          score_mode: "max"
        }
      }
    end


    # Build unique cache key
    base_key = [
      "products_page", page,
      ("category_#{category_id}" if category_id),
      ("name_#{search_name}" if search_name),
      ("min_#{min_price}" if min_price),
      ("max_#{max_price}" if max_price),
      ("colors_#{color_ids.join('-')}" if color_ids&.any?),
      ("sizes_#{size_ids.join('-')}" if size_ids&.any?),
      ("sorted_#{sort_order}")
    ].compact.join("_")

    cache_key = "#{base_key}_cache"

    # Fetch from cache or Elasticsearch
    cached_result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      result = Product.search(
        {
          query: query,
          from: (page - 1) * per_page,
          size: per_page,
          sort: [
            {
              "product_variants.price": {
                order: sort_order,
                mode: "min", # sorts by the min price of variants
                nested: { path: "product_variants" }
              }
            }
          ]
        }
      )

      products = result.records

      {
        data: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductsSerializer).as_json,
        meta: elasticsearch_pagination_meta(page, per_page, result.response['hits']['total']['value'])
      }
    end

    render_response(
      data: cached_result[:data],
      message: "Get all products successfully",
      status: 200,
      meta: cached_result[:meta]
    )
  end

  # GET /products/1 or /products/1.json
  def show
    product = Product.without_deleted.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Product not found" if product.nil?
    render_response(data: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductsSerializer),
                    message: "Get product successfully",
                    status: 200
    )
  end
end
