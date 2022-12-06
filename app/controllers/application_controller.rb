class ApplicationController < ActionController::API
    SECRET="AlbertKofiLawer"

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

end
