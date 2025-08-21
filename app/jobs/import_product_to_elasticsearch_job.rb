class ImportProductToElasticsearchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = Product.__elasticsearch__.client
    client.indices.delete(index: Product.index_name) rescue nil
    Product.__elasticsearch__.create_index!(force: true)

    Product.find_each(batch_size: 100) do |product|
      begin
        product.__elasticsearch__.index_document
      rescue => e
        Rails.logger.error("Failed to index product #{product.id}: #{e.message}")
      end
    end
  end
end
