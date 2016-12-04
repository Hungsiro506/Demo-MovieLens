class SearchController < ApplicationController
	def search
		if params[:term].nil?
			@articles = []
		else
			term = params[:term]
			@articles = Movie.search term, fields: [:imdb_tagline], highlight:  true

			
		end
	end

	def typeahead
		render json: Movie.search(params[:term], {
      fields: [:imdb_tagline],
      limit: 10,
      load: false,
      misspellings: {below: 5},
    }).map do |article| { title: article.title, value: article.id } end
	end
end
