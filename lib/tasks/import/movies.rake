require 'rainbow/ext/string'
require 'csv'
include ActionView::Helpers::NumberHelper
#MOVIES_FILE = Rails.root.join('data', 'movies.dat')
MOVIES_FILE = Rails.root.join('data', 'movies.csv')

namespace :import do
  desc 'Import movies into database'
  task movies: :environment do
    
    puts 'Deleting existing movies!'.color(:yellow)
    Movie.delete_all

    puts 'Starting import...'.color(:green)

    File.open(MOVIES_FILE, "r:UTF-8").each_line do |line|
      puts "Reading line #{number_with_delimiter $INPUT_LINE_NUMBER}..."
      
      if ! line.valid_encoding?
       line = line.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      end
      puts "line : " + line
        #20M data set :
        data = line.split(',')
      #10M data set :
        #data = line.split('::')

      movie = Movie.new
      movie.movielens_id = data[0]
      movie.title = data[1].force_encoding("UTF-8")

      genres = data[2].force_encoding("UTF-8").chomp.split('|')
      movie.genres = genres

      if movie.save
        puts "Movie #{movie.id} saved!".color(:green)

      else
        puts "Movie failed to save! #{movie.errors.full_messages.join('; ')}".color(:red)
      end
    end
    puts 'Done!'.color(:green)
  end
end
