require 'rails_helper'

RSpec.describe "Sessions", type: :request do
    let(:builder) { create(:user) }
    let(:signup_params){
        {fullname: Faker::Name.unique.name, email: Faker::Internet.email, password: Faker::Internet.password}
    }
    let(:invalid_signup_params){
        {fullname: "", email: Faker::Internet.email, password: Faker::Internet.password}
    }
    let(:login_params){
        {email: Faker::Internet.email, password: Faker::Internet.password}
    }

    describe "Post /signup" do
        it "should return http success" do
            post "/signup", params: signup_params, as: :json
            expect(response).to have_http_status(:created)
        end
        
        it "should return http failed" do
            post "/signup", params: invalid_signup_params, as: :json
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end


    describe "Post /login" do
        it "should return http unauthorized" do
            post "/login", params: login_params, as: :json
            expect(response).to have_http_status("401")
        end
        
        it "should return http ok" do
            post "/login", params: {email: builder.email, password: builder.password}, as: :json
            expect(response).to have_http_status(:ok)
        end
        
        it "should return a token in the body" do
            post "/login", params: {email: builder.email, password: builder.password}, as: :json
            expect(response.content_type).to match(a_string_including("application/json"))
        end
    end
    
    
end
