class MoviesController < ApplicationController
    include TmdbApi
    before_action :authentication
    
    def search
        the_resp = get_movie_list(movie_params["name"])
        render json: {message: "Success", count: the_resp['total_results'], data: the_resp['results']}, status: :ok
    end

    def details
        the_resp = get_movie_details(movie_params['movie_id'])
        render json: {message: "Success",  data: the_resp}, status: :ok
    end

    def add_to_list
        user_id = @theResp[0]['user_id']
        _checker = UserMovie.where(user_id: user_id, movie_id: movie_params['movie_id']).count
        if _checker > 0
            render json: {message: "Movie already part iof your list"}, status: :ok
        else
            _checker_two = UserMovie.where(user_id: user_id).count
            if _checker_two >= 100
                render json: {message: "You have hit your cap of 100 movies"}, status: :ok
            else
                _new_entry = UserMovie.new(movie_params)
                _new_entry.user_id = user_id
                if _new_entry.save
                    render json: {message: "Success"}, status: :created
                else
                    render json: {message: "Failure", data: _new_entry.errors}, status: :unprocessable_entity
                end
            end
        end
    end

    protected
        def movie_params
            params.permit(:name,:movie_id)
        end
end
