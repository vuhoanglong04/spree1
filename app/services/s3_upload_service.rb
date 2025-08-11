require "aws-sdk-s3"

class S3UploadService
  def self.upload(file:, folder:)
    bucket = Rails.application.credentials.dig(:aws, :bucket)
    region = Rails.application.credentials.dig(:aws, :region)
    key = File.join(folder, "#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_#{file.original_filename.parameterize}")

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )

    s3.put_object(
      bucket: bucket,
      key: key,
      body: file,
      content_type: file.content_type || 'application/octet-stream',
      acl: 'public-read'
    )

    "https://#{bucket}.s3.#{region}.amazonaws.com/#{key}"
  end

  def self.delete_by_url(url)
    bucket = Rails.application.credentials.dig(:aws, :bucket)
    region = Rails.application.credentials.dig(:aws, :region)

    # Extract the key from the URL
    uri = URI.parse(url)
    key = uri.path[1..] # remove leading slash

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )

    s3.delete_object(bucket: bucket, key: key)
    true
  rescue => e
    Rails.logger.error("Failed to delete S3 object: #{e.message}")
    false
  end
end