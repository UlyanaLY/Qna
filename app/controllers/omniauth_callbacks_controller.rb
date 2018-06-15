class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
   end
  end
end