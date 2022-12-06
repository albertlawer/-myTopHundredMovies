class SessionsController < ApplicationController

    def signup
        user = User.new(user_params)
        if user.save
            token = encode_token(user, valid_for_minutes=60)
            render json: {message: "Success", token: token}, status: :created
        else
            render json: {message: "Invalid setup", errors: user.errors}, status: :unprocessable_entity
        end
    end

    def login
        user = User.find_by(email: user_params[:email])
        if user && user.password == user_params[:password]
            token = encode_token(user, valid_for_minutes=60)
            render json: {message: "Success", token: token}, status: :ok
        else
            render json: {message: "Wrong username/password"}, status: "401"
        end
    end


    protected
        def user_params
            params.permit(:fullname, :email, :password)
        end
end
