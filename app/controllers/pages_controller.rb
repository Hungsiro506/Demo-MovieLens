class PagesController < ApplicationController
  def home
    @top_movies = Movie.complete.order('cached_rating_count DESC').take(25)
    # Create client object.
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])

    # Query PredictionIO.
    if current_user
      response = client.send_query('user' => current_user.id, 'num' => 25)
      puts "Personal Recommend : "
      puts response
    else
      response = client.send_query('user' => -1, 'num' => 25)
    end
    @recomendations = []
    # Loop though recomendations.
    response['itemScores'].each do |item|
      @recomendations << Movie.where(movielens_id: item['item']).take
    end
    @catogories_like = []
    
    bias_unlike = 0
    if current_user
      bias_unlike = current_user.categories.un_like.blank? ? 0 : -1.02
    end

    if current_user && current_user.categories
      @http = PredictionIO::Connection.new(URI(ENV['PIO_ENGINE_URL']), 1, 60)
      h = {}
      h['user'] =  current_user.id.to_s
      h['fields'] = [{"name" => "categories", "values" => current_user.categories.un_like.pluck(:name).to_a, "bias" => bias_unlike}, {"name" => "categories", "values" =>  current_user.categories.like.pluck(:name).to_a, "bias" => 1.02}]
      h['num'] = 25
      puts 'Persional Recommend request: '
      puts h
      response2 = @http.apost(PredictionIO::AsyncRequest.new(
        "/queries.json?accessKey=#{ENV['PIO_ACCESS_KEY']}", h.to_json
      )).get
      puts 'Response  for Persional Recs '
      puts response2
      # Loop though recomendations.
      eval(response2.body)[:itemScores].each do |item|
        @catogories_like << Movie.where(movielens_id: item[:item]).take
      end
    end

  end
end
