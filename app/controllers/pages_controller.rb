class PagesController < ApplicationController
  def home
    @top_movies = Movie.complete.order('cached_rating_count DESC').take(25)
    # Create client object.
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])

    # Query PredictionIO.
    response = client.send_query('user' => current_user.id, 'num' => 25)
    p response
    @recomendations = []
    # Loop though recomendations.
    response['itemScores'].each do |item|
      @recomendations << Movie.where(movielens_id: item['item']).take
    end
    @catogories_like = []

    if current_user && current_user.category_users
      @http = PredictionIO::Connection.new(URI(ENV['PIO_ENGINE_URL']), 1, 60)
      h = {}
      h['user'] = current_user.id
      h['fields'] = [{"name" => "categories", "values" => [current_user.category_users.like.to_a], "bias": -1}, {"name" => "categories", "values" => [current_user.category_users.un_like.to_a], "bias": 1.02}]
      h['num'] = 25
      response2 = @http.apost(PredictionIO::AsyncRequest.new(
        "/queries.json?accessKey=#{ENV['PIO_ACCESS_KEY']}", h.to_json
      )).get

      # Loop though recomendations.
      eval(response2.body)[:itemScores].each do |item|
        @catogories_like << Movie.where(movielens_id: item[:item]).take
      end
    end

  end
end
