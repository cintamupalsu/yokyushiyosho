class YokyushiyoshoController < ApplicationController
  before_action :logged_in_user
  
  def create_torikomi
    first_row = sakusei_params['first_row'].to_i-1
    p_col = string_to_col(sakusei_params['parent'])
    c_col = Array.new(sakusei_params['child'].length)
    child_id = Array.new(sakusei_params['child_id'].length)
    (0..c_col.length-1).each do |i|
      c_col[i]= string_to_col(sakusei_params['child'][i])
      child_id[i] = sakusei_params['child_id'][i].to_i
    end
    
    filexls = sakusei_params["filename"]
    workbook = RubyXL::Parser.parse(filexls.path)
    worksheet=workbook[0]
    if sakusei_params["worksheetname"]!=""
      worksheet=workbook[sakusei_params["worksheetname"]]
    end    
    yokyu_parent = YokyuParent.where("flag = 0 AND default_set = 1 AND user_id =?", current_user.id).first
    file_manager = FileManager.create(name: filexls.original_filename, user_id: current_user.id)
    @count_records = 0
    (first_row..worksheet.count-1).each do |i|
      if worksheet[i][p_col].value.to_s != "" 
        @count_records+=1
        yokyu_denpyo_parent = YokyuDenpyo.create(content: worksheet[i][p_col].value.to_s, 
                                       user_id: current_user.id, 
                                       yokyu_parent_id: yokyu_parent.id, 
                                       hospital: sakusei_params['hospital'].to_i,
                                       vendor: sakusei_params['vendor'].to_i,
                                       child: -1,
                                       parent: -1,
                                       file_manager_id: file_manager.id)
        (0..child_id.length-1).each do |j|
          yokyu_denpyo = YokyuDenpyo.create(content: worksheet[i][c_col[j]].value.to_s, 
                               user_id: current_user.id, 
                               yokyu_parent_id: yokyu_parent.id, 
                               hospital: sakusei_params['hospital'].to_i,
                               vendor: sakusei_params['vendor'].to_i,
                               child: child_id[j],
                               parent: yokyu_denpyo_parent.id,
                               file_manager_id: file_manager.id)
  
        end
      end
    end
    @user = User.find(current_user.id)
    @yokyu_parent = YokyuParent.where("user_id = ? AND default_set = ?", @user.id, 1)
    flash[:info] = "#{@count_records}行を登録しました"
    redirect_to shiyosho_path(:id => current_user)
    #[row][col]
    #@paramkocok = p_col#worksheet[6][p_col].value
    
    #@paramkocok = @paramkocok['sakusei']['child']
    #@companies = Company.where("flag = 0")
  end

  def create_sakusei
    
    p_col = string_to_col(sakusei_params['parent'])
    c_col = Array.new(sakusei_params['child'].length)
    child_id = Array.new(sakusei_params['child_id'].length)
    
    (0..c_col.length-1).each do |i|
      c_col[i]= string_to_col(sakusei_params['child'][i])
      child_id[i] = sakusei_params['child_id'][i].to_i
    end

    filexls = sakusei_params["filename"]
    workbook = RubyXL::Parser.parse(filexls.path)
    worksheet=workbook[0]
    if sakusei_params["worksheetname"]!=""
      worksheet=workbook[sakusei_params["worksheetname"]]
    end    
    
    #cell_value = worksheet[1][9].value
    #flash[:info] = workbook[0].sheet_name
    # redirect_to shiyosho_path(:id => current_user)
    
    (0..worksheet.count-1).each do |i|
      if worksheet[i][p_col] != nil
      if worksheet[i][p_col].value.to_s != "" 
        yokyu_denpyo_parent = YokyuDenpyo.where("content = ? AND parent = -1", worksheet[i][p_col].value.to_s).first
        if yokyu_denpyo_parent != nil
          (0..child_id.length-1).each do |j|
            yokyu_denpyo_child = YokyuDenpyo.where("parent = ? AND child = ?", yokyu_denpyo_parent.id, child_id[j]).first
            if yokyu_denpyo_child.content != ""
              if worksheet[i][c_col[j]] == nil
                worksheet.add_cell(i, c_col[j] , yokyu_denpyo_child.content)
              else
                worksheet[i][c_col[j]].change_contents(yokyu_denpyo_child.content, worksheet[i][c_col[j]].formula)
                
              end
            end
          end
        end
      end
      end
    end
    workbook.write(filexls.path)
    send_data( workbook.stream.read, :disposition => 'attachment', :type => 'application/excel', :filename => filexls.original_filename)
    
    
    #yokyu = sakusei_params
    #filexls = yokyu['filename']
    #workbook = RubyXL::Parser.parse(filexls.path)
    #worksheet = workbook[0]
    #cell_value = worksheet[0][0].value
    #@sakusei = filexls.original_filename
    #worksheet.add_cell(1, 1 ,"Text B2")
    #workbook.write(filexls.path)
    #send_data( workbook.stream.read, :disposition => 'attachment', :type => 'application/excel', :filename => filexls.original_filename)
    
  end

  def sakusei
    #@user = User.find(current_user.id)
    @user = User.find(params[:id])
    @yokyu_parent = YokyuParent.where("user_id = ? AND default_set = ?", @user.id, 1)
    #@paramkocok = params
  end
  
  private
  # Parameters protection
  def sakusei_params
    params.require(:sakusei).permit(:filename, :worksheetname, :vendor, :hospital, :parent, :first_row, :child=>[], :child_id=>[])
  end
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end  
  
  def string_to_col(colname)
    colname = colname.upcase
    colnumber = 0
    (1..colname.length).each do |i|
      j=colname.length-i
      ordval=colname[j].ord
      if ordval<65 || ordval>90; return -1 end
      colnumber += (ordval-65)*26**(i-1)
    end
    colnumber
  end
  
end
