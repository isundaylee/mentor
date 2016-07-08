class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.name = auth.info.name
      u.oauth_token = auth.credentials.token
      u.oauth_token_expires_at = Time.at(auth.credentials.expires_at)

      u.save!
    end
  end
end
