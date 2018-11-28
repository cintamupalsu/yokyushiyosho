class FileManagersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  def index
    @user = User.find(params[:id])
    @file_managers = FileManager.where("user_id = ?", @user.id).paginate(page: params[:page])
  end

  def new
  end

  def edit
  end

  def show
  end
  
  def destroy
    
    file_manager = FileManager.find(params[:id])
    yokyu_denpyos = YokyuDenpyo.where("file_manager_id = ?", file_manager.id)
    ydc = yokyu_denpyos.count
    FileManager.find(params[:id]).destroy
    flash[:success] = "#{ydc}伝票を削除しました"
    redirect_to file_managers_url(:id => current_user.id)
  end

  
  private
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

end
