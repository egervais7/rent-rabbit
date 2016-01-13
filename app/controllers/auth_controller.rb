class AuthController < ApplicationController

  def callback
    provider_user = request.env['omniauth.auth']
    puts "hello"
    puts provider_user

    @user = User.find_or_create_by(pid: provider_user['uid'], provider: params[:provider]) do |u|
      u.token = provider_user['credentials']['token']
      u.first_name = provider_user['info']['name'].split(' ').first
      u.last_name = provider_user['info']['name'].split(' ').second
      u.email = provider_user['info']['email']
      u.password = params[:provider]
    end

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
  	redirect_to root_path
  end

  def failure
    render plain: 'failure'
  end

end
