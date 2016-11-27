require 'rainbow/ext/string'
require 'net/http'
require 'omdbapi'
require 'omdb'
include ActionView::Helpers::NumberHelper
namespace :import do
  desc 'IMDB stats'
  task imdb_stats: :environment do
    missing_poster_count = Movie.where('poster_url IS NULL').count
    puts "Missing Poster Count: #{number_with_delimiter missing_poster_count}"
  end

  desc 'Import movie fields into database'
  task imdb_fields: :environment do
    success_count = 0
    missing_count = 0
    failed_count = 0

    puts 'Starting IMDb calls...'.color(:green)
    movie_count = Movie.all.count
    Movie.find_each.with_index do |movie, index|
      puts "Starting #{movie.title}... #{number_with_delimiter index + 1} of #{number_with_delimiter movie_count}"


      # mixing using OMDB and IMDB

      #m = Imdb::Movie.new('tt'+ movie.imdb_id)
      # IMDB search for url it doesn't work
      #just for case 833 movie doesn't have
      if movie.imdb_id
        m = OMDB.id(movie.imdb_id)
        if !m.key?(:error)
          puts "Updating IMDB ID #{movie.imdb_id}!"
          
          movie.poster_url = m.poster
          movie.imdb_tagline = m.plot if m.plot
          #puts m.poster
          movie.movie_type = m.type
          movie.year = m.year
          actors = m.actors.chomp
          #puts actors
          movie.actors = actors.split(',')

          if movie.save
            puts "Movie #{movie.title} saved!".color(:green)
            success_count += 1
          else
            error = "Movie ##{movie.id} #{movie.title} failed! #{e.errors.full_messages.join('; ')}".color(:red)
            RakeLogger.error error
            puts error.color(:red)
            failed_count = 0
          end
        else
          error = "Movie ##{movie.id} #{movie.title} was not found!"
          RakeLogger.error error
          puts error.color(:red)
          missing_count += 1
        end
      end

    end

    puts 'Done!'.color(:green)

    puts "Success: #{success_count}"
    puts "Missing: #{missing_count}"
    puts "Failed: #{failed_count}"
  end

  desc 'Import movies into database'
  task imdb_search: :environment do
    success_count = 0
    missing_count = 0
    failed_count = 0

    puts 'Starting IMDb calls...'.color(:green)
    movie_count = Movie.all.count
    Movie.find_each.with_index do |movie, index|
      puts "Starting #{movie.title}... #{number_with_delimiter index + 1} of #{number_with_delimiter movie_count}"
      if !movie.imdb_id
        
     
        i = Imdb::Search.new(movie.title)

        if i.movies.size > 0
          m = i.movies.first
          imdb_id = m.id

          puts "Adding IMDB ID #{imdb_id}!"
          movie.imdb_id = 'tt'+imdb_id
          #puts m.mpaa_rating
          movie.imdb_mpaa_rating = m.mpaa_rating
          #puts m.rating
          movie.imdb_rating = m.rating
          #puts m.tagline
          movie.imdb_tagline = m.tagline
          #puts m.url.chomp("combined")
          #puts m.url[0...-4]
          movie.imdb_url = m.url.chomp('combined')
          #puts m.votes
          movie.imdb_votes = m.votes

          if movie.save
            puts "Movie #{movie.title} saved!".color(:green)
            success_count += 1
          else
            error = "Movie ##{movie.id} #{movie.title} failed! #{e.errors.full_messages.join('; ')}".color(:red)
            RakeLogger.error error
            puts error.color(:red)
            failed_count = 0
          end
        else
          error = "Movie ##{movie.id} #{movie.title} was not found!"
          RakeLogger.error error
          puts error.color(:red)
          missing_count += 1
        end
      end 
    end

    puts 'Done!'.color(:green)

    puts "Success: #{success_count}"
    puts "Missing: #{missing_count}"
    puts "Failed: #{failed_count}"
  end
end
