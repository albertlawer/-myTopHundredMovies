module TmdbApi
    
    HEADERS = {'Content-Type'=> 'application/json','timeout'=>ENV["STROPENTIMEOUT"], 'open_timeout'=>ENV["STROPENTIMEOUT"]}
    CONN = Faraday.new(:url => ENV["TMDB_URL"], :headers => HEADERS, :ssl => {:verify => false}) do |faraday|   
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    def get_movie_list(theQuery)
        endpoint = "/3/search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{ theQuery }"
        res=CONN.get do |req|
            req.url endpoint
            req["Authorization"]="Bearer #{ENV['TMDB_TOKEN']}"
        end
        resp = JSON.parse(res.body)
        return resp
    end

    def get_movie_details(the_id)
        endpoint = "/3/movie/#{the_id}?api_key=#{ENV['TMDB_API_KEY']}"
        res=CONN.get do |req|
            req.url endpoint
            req["Authorization"]="Bearer #{ENV['TMDB_TOKEN']}"
        end
        resp = JSON.parse(res.body)
        return resp
    end
end