require 'rainbow/ext/string'
require 'csv'
include ActionView::Helpers::NumberHelper
THREADS = 200
namespace :import do
  desc 'Send the data to PredictionIO'
  task recommendation: :environment do
    start_time = Time.current
    #puts "Started at: #{start_time}".color(:blue)
    #puts ENV['PIO_ACCESS_KEY']
    #puts ENV['PIO_EVENT_SERVER_URL']
    client = PredictionIO::EventClient.new(ENV['PIO_ACCESS_KEY'], ENV['PIO_EVENT_SERVER_URL'], THREADS)
    
    #puts client
    puts 'Starting import...'.color(:blue)


    puts 'Starting rating import...'.color(:blue)

    rating_count = Rating.all.count
    Rating.find_each.with_index do |rating, index|

      if rating.rating > 3
        r = Random.rand(0,2)
        if r > 1 
          client.acreate_event(
          'buy',
          'user',
          rating.movielens_user_id.to_s, {
            'targetEntityType' => 'item',
            'targetEntityId' => rating.movielens_movie_id.to_s
            }
          )
        end
      end

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
