class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #"if user"=>Taking into account that any object other than nil and false itself is true in a boolean context 
      #log_in user
      #remember user
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_to user # Rails automatically converts this to the route for the user’s profile page: user_url(user)
      #redirect_back_or user
      
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = '無効なメールやパスワードなど。'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
