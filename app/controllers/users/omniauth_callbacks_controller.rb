class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_callback('facebook')
  end

  def google_oauth2
    oauth_callback('google')
  end

  private
  def oauth_callback(provider)
    @user = User.from_omniauth(provider, request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => provider.titleize) if is_navigational_format?
    else
      session["devise.oauth_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
