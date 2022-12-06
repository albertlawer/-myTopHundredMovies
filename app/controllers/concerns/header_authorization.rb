module HeaderAuthorization
    SECRET= ENV["JWT_SECRET"]

    def authentication
        token = request.headers["HTTP_AUTHORIZATION"]
        if token.nil?
            render json: {message: "Missing Token, Please add token to the headers to access"}, status: :unauthorized
        else
            theResp = decode_token(token)
            if !theResp[0]
                render json: {message: theResp[1]}, status: :unauthorized
            end
            @theResp = theResp[1]
        end
    end

    def encode_token(user, valid_minutes)
        exp = Time.now.to_i + (valid_minutes*60)
        payload={ "iss": "albertlawer",
                "exp": exp,
                "name": user.fullname,
                "user_id": user.id,
                "user_email": user.email
                }
        token = JWT.encode payload, SECRET, 'HS256'
        return token
    end
    
    def decode_token(token)
        unless token
          return [false,""]
        end
    
        token.gsub!('Bearer ','')
        begin
          decoded_token = JWT.decode token, SECRET, true
          return [true,decoded_token]
        rescue JWT::DecodeError => e
            return [false,"Error decoding the JWT: "+ e.to_s]
        end
    end

end