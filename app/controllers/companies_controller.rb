class CompaniesController < ApplicationController
  def new
    if params[:client]=="true"
      @client=true
    else
      @client=false
    end
    @company = Company.new
  end

  def edit
    @company = Company.find(params[:id])
    @user = current_user
    if @company.company_type_id == 1 
      @client = true
    else
      @client = false
    end
  end
  
  def create
    @company = Company.new(company_params)
    @company.flag=0
    @company.user_id = current_user.id
    if @company.save
      if @company.company_type_id==1
        flash[:info] = "病院を登録した"
        @client = true
      else
        flash[:info] = "ベンダーを登録した"
        @client = false
      end
        redirect_to companies_path(:id => current_user, :client => @client)
    else
      @user = User.find(current_user.id)
      render 'new'
    end
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(company_params)
      if @company.company_type_id ==1
       flash[:success] = "病院を編集した"
       @client = true
     else
       flash[:success] = "ベンダーを編集した"
       @client = false
     end
     redirect_to companies_path(:id => current_user, :client => @client)
    else
       render 'edit'
    end
  end

  def show
  end

  def index

    if params[:client]=="true"
      @client=true
    else
      @client=false
    end
    @company_types = CompanyType.where("client = ? AND Flag = 0", @client)
    
    cti = Array.new(@company_types.count) # array of company type ids
    cti_counter=0
    @company_types.each do |company_type|
      cti[cti_counter]=company_type.id
      cti_counter+=1
    end
    @companies = Company.where("company_type_id IN (?) AND Flag = 0", cti).paginate(page: params[:page])
    @user = User.find(params[:id])
    
  end
  
  def destroy
    @company = Company.find(params[:id])
    @company.update_attributes(flag: 1)
    if @company.company_type_id == 1
      flash[:success] = "病院を削除しました"
      @client = true
    else
      flash[:success] = "ベンダーを削除しました"
      @client = false
    end
    redirect_to companies_path(:id => current_user, :client => @client)
  end

  
  private
  
  def company_params
    params.require(:company).permit(:name, :address, :company_type_id)
  end
  
  
  
end
