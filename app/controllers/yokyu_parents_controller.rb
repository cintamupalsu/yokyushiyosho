class YokyuParentsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  def index
    @yokyu_parents=YokyuParent.where("user_id = ? AND flag = ?", current_user.id, 0).paginate(page: params[:page])
    @user = User.find(params[:id])
  end

  def new
    @user = User.find(params[:id])
    @yokyu_parent = YokyuParent.new 
  end
  
  def create
    @yokyu_parent = YokyuParent.new(yokyu_parent_params)
    @yokyu_parent.flag = 0
    if YokyuParent.count == 0
      @yokyu_parent.default_set = 1
    else
      @yokyu_parent.default_set = 0
    end
    @yokyu_parent.user_id = current_user.id
      #if User.count==0 
      #   @user.admin=true
      #end
    if @yokyu_parent.save
      flash[:info] = "要求仕様書列を登録した"
      redirect_to yokyu_parents_path(:id => current_user)
    else
      @user = User.find(current_user.id)
      render 'new'
    end

    #redirect_to yokyu_parents_path(:id => current_user)
  end

  def show
    @yokyu_parent = YokyuParent.find(params[:id])
    @user = @yokyu_parent.user
  end

  def edit
    @yokyu_parent = YokyuParent.find(params[:id])
    @user = @yokyu_parent.user
  end
  
  def update
    @yokyu_parent = YokyuParent.find(params[:id])
    if @yokyu_parent.update_attributes(yokyu_parent_params)
       flash[:success] = "列を編集した"
       redirect_to yokyu_parents_path(:id => current_user)
    else
       render 'edit'
    end
  end
  
  def default
    @yokyu_parent = YokyuParent.find(params[:id])
    yokyu_parents = YokyuParent.where("user_id = ? AND flag = ?", current_user.id, 0)
    
    yokyu_parents.each do | yokyu_parent |
      if yokyu_parent.id != @yokyu_parent.id
        if yokyu_parent.default_set==1
          yokyu_parent.update_attributes(default_set: 0)
        end
      else
        yokyu_parent.update_attributes(default_set: 1)
      end
    end
    redirect_to yokyu_parents_path(:id => current_user)
  end
  
  def destroy
    @yokyu_parent = YokyuParent.find(params[:id])
    @yokyu_parent.update_attributes(flag: 1)
    flash[:success] = "要求仕様書列を削除しました"
    redirect_to yokyu_parents_path(:id => current_user)
  end

  
  private
  
  def yokyu_parent_params
    params.require(:yokyu_parent).permit(:name, :default_col)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

end
