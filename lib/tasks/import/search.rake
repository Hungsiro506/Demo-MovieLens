require 'elasticsearch/model'
include ActionView::Helpers::NumberHelper
namespace :import do
  desc 'ES import stats'
  task search: :environment do
Movie.__elasticsearch__.client = Elasticsearch::Client.new hosts: [
  { host: 'search-butterflyhub-sycvprrdhsanhunjdquiuvi36y.us-west-2.es.amazonaws.com',
    port: '443',
    scheme: 'https'
  } ]



  # Create the new index with the new mapping
Movie.__elasticsearch__.client.indices.create \
  index: Movie.index_name,
  body: { settings: Movie.settings.to_hash, mappings: Movie.mappings.to_hash }
=begin
  
rescue Exception => e
  
end
# Delete the previous articles index in Elasticsearch
#Article.__elasticsearch__.client.indices.delete index: Article.index_name rescue nil

# Create the new index with the new mapping
#Article.__elasticsearch__.client.indices.create \
  index: Article.index_name,
  body: { settings: Article.settings.to_hash, mappings: Article.mappings.to_hash }

# Index all article records from the DB to Elasticsearch

=end
Movie.import
end
end