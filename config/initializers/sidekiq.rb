Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }

  Sidekiq::Cron::Job.create(
    name: 'Sync Product Variants With Stripe',
    cron: '0 0 /3 * *',
    class: 'UpdateProductVariantToStripeJob',
    queue: 'default'
  )

  Sidekiq::Cron::Job.create(
    name: 'Import Product To ElasticSearch',
    cron: '0 0 /4 * *',
    class: 'ImportProductToElasticsearchJob',
    queue: 'default'
  )

  Sidekiq::Cron::Job.create(
    name: 'Delete Expired Refresh Token',
    cron: '0 0 /5 * *',
    class: 'DeleteExpiredRefreshTokenJob',
    queue: 'default'
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
