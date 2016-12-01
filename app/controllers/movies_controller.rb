class MoviesController < ApplicationController
  def index
    @movies = Movie.complete.order('cached_rating_count DESC').page(params[:page])
  end

  def show
    @movie = Movie.find(params[:id])
    @rating = current_user.rateds.where(movie_id: @movie.id).first unless current_user.blank?
    p @rating
    # Create PredictionIO client.
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])

    # Query PredictionIO.
    response = client.send_query('item' => @movie.id, 'num' => 4)
    
    @catogories_like = []
    if current_user && current_user.category_users
      @http = PredictionIO::Connection.new(URI(ENV['PIO_ENGINE_URL']), 1, 60)
      h = {}
      h['user'] = current_user.id
      h['userBias'] = 2
      h['item'] = movie.id
      h['fields'] = [{"name" => "categories",  "values" => current_user.category_users.like.to_a, "bias": 1}, {"name" => "categories", "values" => current_user.category_users.un_like.to_a, "bias": -1.02}]
      h['num'] = 4
      response2 = @http.apost(PredictionIO::AsyncRequest.new(
        "/queries.json?accessKey=#{ENV['PIO_ACCESS_KEY']}", h.to_json
      )).get
      # Loop though recomendations.
      eval(response2.body)[:itemScores].each do |item|
        @catogories_like << Movie.where(movielens_id: item[:item]).take
      end
    end

    @recomendations = []
    # Loop though recomendations.
    response['itemScores'].each do |item|
      @recomendations << Movie.where(movielens_id: item['item']).take
    end
  end

  def rate
    rating = current_user.rateds.where(movie_id: params[:movie_id]).first_or_create
    rating.update_attributes(rate: params[:rate])
    client = PredictionIO::EventClient.new(ENV["PIO_ACCESS_KEY"], ENV["PIO_EVENT_SERVER_URL"])

    # A user rates an item.
    client.create_event(
      'rate',
      'user',
      current_user.id, {
        'targetEntityType' => 'item',
        'targetEntityId' => params[:movie_id],
        'properties' => { 'rating' => params[:rate].to_f}
      }
    )
    return head :ok
  end
end
