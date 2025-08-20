require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"],
  # user: "longdz2004",
  # password: "W6Fx-UBaJm5Do3Oo11*f",
  log: true
)
