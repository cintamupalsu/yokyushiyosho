class UsersController < ApplicationController
   before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
   before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy
   
   def index
      @users = User.paginate(page: params[:page])
   end
   
   def show
     @user = User.find(params[:id])  
   end
  
   def new
      @user = User.new
   end
  
   def create
      @user = User.new(user_params)
      
      # on IBM Cloud unmark these
      #@user.activated = true
      #@user.activated_at = Time.zone.now
      #if User.count==0 
      #   @user.admin=true
      #end
      #--------------------------
      if @user.save
         #log_in @user
         #flash[:success] = "PK-Tools on Watsonへようこそ。"
         #redirect_to @user
         
         # on IBM Cloud unmark these
         #if User.count==1
         #CompanyType.create!(name: "病院",
         #           client: true,
         #           flag: 0,
         #           user_id: 1)
         #CompanyType.create!(name: "ベンダー",
         #           client: false,
         #           flag: 0,
         #           user_id: 1)
         #end
         
         #YokyuParent.create!(name: "仕様書内容", flag: 0, user_id: @user.id, default_col: "D", default_set: 1)
         #yokyu_parent = YokyuParent.last
         #YokyuChild.create!(name: "回答", flag: 0, user_id: @user.id, default_col: "E", yokyu_parent_id: yokyu_parent.id)
         #YokyuChild.create!(name: "備考", flag: 0, user_id: @user.id, default_col: "H", yokyu_parent_id: yokyu_parent.id)

         #----------------------------
         @user.send_activation_email
         
         #UserMailer.account_activation(@user).deliver_now
         flash[:info] = "アカウントを有効するためにメールを確認してください。"
         redirect_to root_url
      else
         render 'new'
      end
   end
   
   def edit
      @user = User.find(params[:id])
   end
   
   def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
         flash[:success] = "プロファイルを編集した"
         redirect_to @user
      else
         render 'edit'
      end
   end

   def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
   end
   
   private
   
   def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
   
   # Before filters
   
   # Confirms a logged-in user.
   def logged_in_user
      unless logged_in?
         store_location
         flash[:danger] = "ログインしてください。"
         redirect_to login_url
      end
   end
   
   # Confirms the correct user.
   def correct_user
      @user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
   end
   
   # Confirms an admin user.
   def admin_user
      redirect_to(root_url) unless current_user.admin?
   end
end
