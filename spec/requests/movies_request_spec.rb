require 'rails_helper'
include HeaderAuthorization

RSpec.describe "Movies", type: :request do
    let(:a_user){create(:user)}
    let(:movie_search){{ name: Faker::Movie.title }}

    describe "Get movies" do
        it "returns unathorized" do
            get "/search"
            expect(response).to have_http_status(:unauthorized)
        end
        
        it "returns http success" do
            get "/search", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: movie_search
            expect(response).to have_http_status(:success)
        end
    end

    describe "Get movie details" do
        it "returns unathorized" do
            get "/details"
            expect(response).to have_http_status(:unauthorized)
        end
        
        it "returns http success" do
            get "/search", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: movie_search
            theData = JSON.parse(response.body)
            movieData = theData['data']
            theFIrst = movieData.first
            movie_id = theFIrst['id']
            get "/details", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: {movie_id: movie_id}
            expect(response).to have_http_status(:success)
        end
    end


    describe "Add movie to list" do
        it "returns unathorized" do
            post "/add_to_list"
            expect(response).to have_http_status(:unauthorized)
        end

        it "returns http status created" do
            get "/search", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: movie_search
            theData = JSON.parse(response.body)
            movieData = theData['data']
            theFIrst = movieData.first
            movie_id = theFIrst['id']
            the_title = theFIrst['original_title']
            post "/add_to_list", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: {movie_id: movie_id, title: the_title}
            expect(response).to have_http_status(:created)
        end

        it "increases count by 1" do
            get "/search", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: movie_search
            theData = JSON.parse(response.body)
            movieData = theData['data']
            theFIrst = movieData.first
            movie_id = theFIrst['id']
            the_title = theFIrst['original_title']
            expect{post "/add_to_list", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: {movie_id: movie_id, title: the_title}}.to change(UserMovie, :count).by(1)
        end
    end
    
    
    describe "Show movie list" do
        it "returns unathorized" do
            get "/show"
            expect(response).to have_http_status(:unauthorized)
        end

        it "returns http status success" do
            i =0
            while i < 5
                get "/search", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: { name: Faker::Movie.title }
                theData = JSON.parse(response.body)
                movieData = theData['data']
                theFIrst = movieData.first
                movie_id = theFIrst['id']
                the_title = theFIrst['original_title']
                post "/add_to_list", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: {movie_id: movie_id, title: the_title}
                i +=1
            end

            get "/show", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}
            expect(response).to have_http_status(:ok)
        end
    end
    
end
