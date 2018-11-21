class YokyushiyoshoController < ApplicationController
  before_action :logged_in_user
  
  def create_torikomi
  end

  def create_sakusei
  end

  def sakusei
     @user = User.find(current_user.id)
  end
  
  private
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end  
end
