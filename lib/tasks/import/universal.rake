require 'rainbow/ext/string'
require 'csv'
include ActionView::Helpers::NumberHelper
THREADS = 200
namespace :import do
  desc 'Send the data to PredictionIO'
  task predictionio: :environment do
    start_time = Time.current
    #puts "Started at: #{start_time}".color(:blue)
    #puts ENV['PIO_ACCESS_KEY']
    #puts ENV['PIO_EVENT_SERVER_URL']
    client = PredictionIO::EventClient.new(ENV['PIO_ACCESS_KEY'], ENV['PIO_EVENT_SERVER_URL'], THREADS)
    
    #puts client
    puts 'Starting import...'.color(:blue)

   

    puts 'Starting user import...'.color(:blue)
    unique_users = Rating.uniq.pluck(:movielens_user_id)
    user_count = unique_users.count
    unique_users.each_with_index do |user_id, index|
      client.acreate_event(
        '$set',
        'user',
        user_id.to_s
      )
      #puts h
      puts "Sent user ID #{user_id} to PredictionIO. Action #{number_with_delimiter index + 1} of #{number_with_delimiter user_count}"
    end

     puts 'Starting movie import...'.color(:blue)
    movie_count = Movie.all.count
    Movie.find_each.with_index do |movie, index|
      client.acreate_event(
        '$set',
        'item',
        movie.movielens_id.to_s,
        #too much movies factors.
        #{ 'properties' => { 'categories' => movie.genres,'actors' => movie.actors, 'year' => movie.year,'type' => movie.movie_type } }
        { 'properties' => { 'categories' => movie.genres } }
      )
      puts "Sent movie ID #{movie.id} to PredictionIO. Action #{number_with_delimiter index + 1} of #{number_with_delimiter movie_count}"
    end

    puts 'Starting rating import...'.color(:blue)
    rating_count = Rating.all.count
    Rating.find_each.with_index do |rating, index|
      client.acreate_event(
        'rate',
        'user',
        rating.movielens_user_id.to_s, {
          'targetEntityType' => 'item',
          'targetEntityId' => rating.movielens_movie_id.to_s,
          'properties' => { 'rating' => rating.rating.to_f }
        }
      )
      puts "Sent rating ID #{rating.id} to PredictionIO. Action #{number_with_delimiter index + 1} of #{number_with_delimiter rating_count}"
    end
    puts 'Done!'.color(:green)

    finish_time = Time.current
    total_time = finish_time - start_time
    puts "Finished at: #{finish_time}".color(:blue)
    puts "Total #{(total_time / 60).round(4)} minutes!".bright
  end
end
