class YokyuChildrenController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  def index
  end

  def new
    @yokyu_parent = YokyuParent.find(params[:id])
    @user = User.find(params[:user_id])
    @yokyu_child = @yokyu_parent.yokyu_children.build if logged_in?
  end
  
  def create
    #paramkocok = yokyu_child_params
    @yokyu_parent = YokyuParent.find(yokyu_child_params["yokyu_parent_id"])
    @yokyu_child = YokyuChild.new(yokyu_child_params)
    @yokyu_child.user_id = @yokyu_parent.user_id
    @yokyu_child.flag = 0
    if @yokyu_child.save
      flash[:success] = "項目を登録しました。"
      redirect_to yokyu_parent_path(:id => @yokyu_parent.id, :user_id => @yokyu_parent.user_id)
    else 
      @user = User.find(@yokyu_parent.user_id)
      render 'new'
    end
    
  end

  def show
  end

  def edit
    @yokyu_child = YokyuChild.find(params[:id])
    @user = @yokyu_child.user
    @yokyu_parent = @yokyu_child.yokyu_parent
  end
  
  def update
    @yokyu_child = YokyuChild.find(params[:id])
    @yokyu_parent = @yokyu_child.yokyu_parent
    @user = @yokyu_child.user
    if @yokyu_child.update_attributes(yokyu_child_params)
       flash[:success] = "項目を編集した"
       redirect_to @yokyu_parent
    else
       render 'edit'
    end
  end

  def destroy
    @yokyu_child = YokyuChild.find(params[:id])
    @yokyu_child.update_attributes(flag: 1)
    flash[:success] = "要求仕様書列を削除しました"
    redirect_to yokyu_parent_path(:id => @yokyu_child.yokyu_parent.id, :user_id => @yokyu_child.user.id)
  end
  
  private
  
  def yokyu_child_params
    params.require(:yokyu_child).permit(:name, :default_col, :yokyu_parent_id)
  end
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

end
