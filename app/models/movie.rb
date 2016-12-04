
require 'elasticsearch/model'
require "faraday"

class Movie < ActiveRecord::Base
  scope :complete, -> { where('poster_url IS NOT NULL') }
  has_many :ratings, primary_key: :movielens_id, foreign_key: :movielens_movie_id
  has_many :rateds

  searchkick
  def search_data
      {
        title: title,
        imdb_tagline: imdb_tagline
      }
  end
  Searchkick.client = Elasticsearch::Client.new(hosts: [ "http://search-butterflyhub-sycvprrdhsanhunjdquiuvi36y.us-west-2.es.amazonaws.com"], retry_on_failure: true)

end


=begin
  
rescue Exception => e


  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english', index_options: 'offsets'
      indexes :imdb_tagline, analyzer: 'english'

    end
  end
  
=end