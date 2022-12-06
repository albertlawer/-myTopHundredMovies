class MoviesController < ApplicationController
    include TmdbApi
    before_action :authentication
    before_action :get_user_id, only: [:add_to_list, :show]
    
    def search
        the_resp = get_movie_list(movie_params["name"])
        render json: {message: "Success", count: the_resp['total_results'], data: the_resp['results']}, status: :ok
    end

    def details
        the_resp = get_movie_details(movie_params['movie_id'])
        render json: {message: "Success",  data: the_resp}, status: :ok
    end

    def add_to_list
        _checker = UserMovie.where(user_id: @user_id, movie_id: movie_params['movie_id']).count
        if _checker > 0
            render json: {message: "Movie already part iof your list"}, status: :ok
        else
            _checker_two = UserMovie.where(user_id: @user_id).count
            if _checker_two >= 100
                render json: {message: "You have hit your cap of 100 movies"}, status: :ok
            else
                the_resp = get_movie_details(movie_params['movie_id'])
                _new_entry = UserMovie.new(movie_params)
                _new_entry.user_id = @user_id
                _new_entry.title = the_resp['original_title']
                if _new_entry.save
                    render json: {message: "Success"}, status: :created
                else
                    render json: {message: "Failure", data: _new_entry.errors}, status: :unprocessable_entity
                end
            end
        end
    end

    def show
        user = User.find(@user_id)
        user_movies = UserMovie.where(user_id: @user_id).all
        payload={ :user => user.fullname, :data=> user_movies }
        render json: {message: "success", data: payload}, status: :ok
    end

    protected
        def movie_params
            params.permit(:name,:movie_id,:title)
        end

        def get_user_id
            @user_id = @theResp[0]['user_id']
        end
end
