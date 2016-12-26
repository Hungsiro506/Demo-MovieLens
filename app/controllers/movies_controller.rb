class MoviesController < ApplicationController
  def index
    @movies = Movie.complete.order('cached_rating_count DESC').page(params[:page])
  end

  def show
    @movie = Movie.find(params[:id])
    @rating = current_user.rateds.where(movie_id: @movie.id).first unless current_user.blank?
    # Create PredictionIO client.
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL_SML'])
    #client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])
    # Query PredictionIO.
    #response = client.send_query('item' => @movie.id, 'num' => 10)
    response = client.send_query(item: @movie.movielens_id.to_s, num: 10)
    #response = client.send_query('item' => @movie.id, 'num' => 10)
    @catogories_like = []

    bias_unlike = 0
    if current_user
      bias_unlike = current_user.categories.un_like.blank? ? 0 : -1.02
    end

    if current_user && current_user.categories
      @http = PredictionIO::Connection.new(URI(ENV['PIO_ENGINE_URL']), 1, 60)
      h = {}
      h['user'] = current_user.id.to_s
      h['userBias'] = 2
      h['item'] =  @movie.id.to_s 
      h['fields'] = [{"name" => "categories",  "values" => current_user.categories.like.pluck(:name).to_a, "bias" => 1}, {"name" => "categories", "values" => current_user.categories.un_like.pluck(:name).to_a, "bias" => bias_unlike}]
      h['num'] = 10
      puts h
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
      current_user.id.to_s, {
        'targetEntityType' => 'item',
        'targetEntityId' => params[:movie_id].to_s,
        'properties' => { 'rating' => params[:rate].to_f}
      }
    )
    return head :ok
  end


  def show_simply
    @movie = Movie.find(params[:id])
  end  
end
