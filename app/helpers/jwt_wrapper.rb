module JWTWrapper
  extend self

  def encode(payload, expiration = nil)
    expiration ||= Rails.application.secrets.jwt_expiration_hours

    payload = payload.dup
    payload['exp'] = expiration.to_i.hours.from_now.to_i

    JWT.encode payload, Rails.application.secrets.secret_key_base
  end

  def decode(token)
    begin
      decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base

      decoded_token.first
    rescue
      nil
    end
  end
end
