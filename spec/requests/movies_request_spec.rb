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
            post "/add_to_list", headers: {HTTP_AUTHORIZATION: encode_token(a_user,time_to_live=1)}, params: {movie_id: movie_id}
            expect(response).to have_http_status(:created)
        end
        
        
    end
    
    
    
end
