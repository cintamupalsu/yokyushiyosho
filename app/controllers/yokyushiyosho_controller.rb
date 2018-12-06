class YokyushiyoshoController < ApplicationController
  before_action :logged_in_user
  
  def create_torikomi
    threshold=0.1
    first_row = sakusei_params['first_row'].to_i-1
    p_col = string_to_col(sakusei_params['parent'])
    c_col = Array.new(sakusei_params['child'].length)
    child_id = Array.new(sakusei_params['child_id'].length)

    wsfrom = sakusei_params["worksheetfrom"].to_i
    wsto = sakusei_params["worksheetto"].to_i

    @sentence_variant={}
    @sentence_answer={}
    @similar_parent_id={}
    @sentence_origin={}
    @watson_result={}
    
    @count_similar_sentence=0
    @child_id=""
    (0..c_col.length-1).each do |i|
      c_col[i]= string_to_col(sakusei_params['child'][i])
      child_id[i] = sakusei_params['child_id'][i].to_i
      if i==0
        @child_id= sakusei_params['child_id'][i].to_s
      else
        @child_id+= ","+sakusei_params['child_id'][i].to_s
      end
    end
    
    filexls = sakusei_params["filename"]
    workbook = RubyXL::Parser.parse(filexls.path)
    
    (wsfrom..wsto).each do |wsnum|
      
      worksheet=workbook[wsnum]
      #if sakusei_params["worksheetname"]!=""
      #  worksheet=workbook[sakusei_params["worksheetname"]]
      #end    
      yokyu_parent = YokyuParent.where("flag = 0 AND default_set = 1 AND user_id =?", current_user.id).first
      file_manager = FileManager.create(name: filexls.original_filename, user_id: current_user.id)
      @filexls_name = filexls.original_filename
      @hospital = sakusei_params['hospital']
      @vendor = sakusei_params['vendor']
      @count_records = 0
      #flash[:info] = "登録しました"
      #redirect_to shiyosho_path(:id => current_user)
  
      
      natural_language_understanding = IBMWatson::NaturalLanguageUnderstandingV1.new(version: "2018-03-16",iam_apikey: ENV['WATSON_NATURAL_LANGUAGE_KEY_1'], url: "https://gateway.watsonplatform.net/natural-language-understanding/api")
      
  
      (first_row..worksheet.count-1).each do |i|
        
        if worksheet[i][p_col]!=nil 
        if worksheet[i][p_col].value.to_s != "" 
          variant= worksheet[i][p_col].value.to_s.gsub(/。|、|\ |\.|,|　|\n/,'')
          if variant != ""
            @count_records+=1
            #watson_language_master = WatsonLanguageMaster.find_by(content: worksheet[i][p_col].value.to_s)
            watson_language_master = WatsonLanguageMaster.find_by(variant: variant)
            if watson_language_master==nil
              #create watson record
              
              watson_response = natural_language_understanding.analyze(
                #text: worksheet[i][p_col].value.to_s,
                text: variant,
                features: {keywords: {limit: 50, sentiment: 0, emotion: 0}}
              )
              
              # filtering similar sentence (if similar, then anchor to similar record id)
              filter = {}
              chosen_word=0
              (0..watson_response.result["keywords"].length-1).each do |k|
                if watson_response.result["keywords"][k]["relevance"].to_f>threshold
                  chosen_word+=1
                  wlks = WatsonLanguageKeyword.where("keyword = ?", watson_response.result["keywords"][k]["text"])  
                  (0..wlks.count-1).each do |j|
                    if filter[wlks[j].watson_language_master.id]==nil
                      filter[wlks[j].watson_language_master.id]=1
                    else
                      filter[wlks[j].watson_language_master.id]+=1
                    end
                  end
                end
              end
    
              find_similar=-1
              filter.each do |k,v|
                if v == chosen_word
                  find_similar=k.to_i
                end
              end
              
              if find_similar!=-1
                #finalizing similarity check
                master = WatsonLanguageMaster.find(find_similar)
                
                if master.watson_language_keywords.count != chosen_word
                  find_similar = -1
                else
                  #debugger
                  @sentence_origin[@count_similar_sentence] = worksheet[i][p_col].value.to_s
                  answer =""  #Array.new(child_id.length)
                  (0..child_id.length-1).each do |j|
                    if j!=0
                      answer += "█" + worksheet[i][c_col[j]].value.to_s
                    else
                      answer = worksheet[i][c_col[j]].value.to_s
                    end
                  end
                  @sentence_answer[@count_similar_sentence] = answer
                  @sentence_variant[@count_similar_sentence] = variant
                  @similar_parent_id[@count_similar_sentence] = find_similar
                  @watson_result[@count_similar_sentence] = watson_response.result
                  @count_similar_sentence+=1
                end
              end
              
    
              
              if find_similar==-1
                watson_language_master = WatsonLanguageMaster.create(content: worksheet[i][p_col].value.to_s, variant: variant, anchor: find_similar)
                (0..watson_response.result["keywords"].length-1).each do |i|
                  if watson_response.result["keywords"][i]["relevance"].to_f>threshold
                    WatsonLanguageKeyword.create(keyword: watson_response.result["keywords"][i]["text"], 
                                               relevance: watson_response.result["keywords"][i]["relevance"].to_f,
                                               watson_language_master_id: watson_language_master.id)
                  end
                end
              else
                
                # watson_language_master = WatsonLanguageMaster.find(find_similar)
              end
            end
            if find_similar==-1
              yokyu_denpyo_parent = YokyuDenpyo.create(content: worksheet[i][p_col].value.to_s, 
                                             user_id: current_user.id, 
                                             yokyu_parent_id: yokyu_parent.id, 
                                             hospital: sakusei_params['hospital'].to_i,
                                             vendor: sakusei_params['vendor'].to_i,
                                             child: -1,
                                             parent: -1,
                                             file_manager_id: file_manager.id,
                                             watson_language_master_id: watson_language_master.id)
              (0..child_id.length-1).each do |j|
                if worksheet[i][c_col[j]].value.to_s!=""
                  yokyu_denpyo = YokyuDenpyo.create(content: worksheet[i][c_col[j]].value.to_s, 
                                     user_id: current_user.id, 
                                     yokyu_parent_id: yokyu_parent.id, 
                                     hospital: sakusei_params['hospital'].to_i,
                                     vendor: sakusei_params['vendor'].to_i,
                                     child: child_id[j],
                                     parent: yokyu_denpyo_parent.id,
                                     file_manager_id: file_manager.id,
                                     watson_language_master_id: watson_language_master.id)
                end
              end
            end
          end
        end
        end
      end
    end #worksheet loop
    @user = User.find(current_user.id)
    @yokyu_parent = YokyuParent.where("user_id = ? AND default_set = ?", @user.id, 1)

    flash[:info] = "#{@count_records}行を登録しました"
    if @count_similar_sentence==0
      redirect_to shiyosho_path(:id => current_user)
    else
      render 'similar'
    end
    #[row][col]
    #@paramkocok = p_col#worksheet[6][p_col].value
    
    #@paramkocok = @paramkocok['sakusei']['child']
    #@companies = Company.where("flag = 0")
  end
  
  def similar
    @user = User.find(current_user.id)
  end
  
  def similar_post
    #@paramkocok = kakunin_params
    threshold=0.1
    itemcount = kakunin_params['watson_parent_id'].count
    @onaji = check_box_bug(kakunin_params['onaji'])
    yokyu_parent = YokyuParent.where("flag = 0 AND default_set = 1 AND user_id =?", current_user.id).first
    file_manager = FileManager.where("name = ? AND user_id =?", kakunin_params['filexls_name'], current_user.id).first
    child_id = kakunin_params['child_id'].split(',')

    (0..itemcount-1).each do |i|
      if @onaji[i]==1
        watson_language_master = WatsonLanguageMaster.create(content: kakunin_params['sentence_origin'][i], variant: kakunin_params['sentence_variant'][i], anchor: kakunin_params['watson_parent_id'][i].to_i)
      else
        watson_language_master = WatsonLanguageMaster.create(content: kakunin_params['sentence_origin'][i], variant: kakunin_params['sentence_variant'][i], anchor: -1)
        (0..kakunin_params['watson_result'][i]["keywords"].length-1).each do |j|
          if kakunin_params['watson_result'][i]["keywords"][j]["relevance"].to_f>threshold
            WatsonLanguageKeyword.create(keyword: kakunin_params['watson_result'][i]["keywords"][j]["text"], 
                                       relevance: kakunin_params['watson_result'][i]["keywords"][j]["relevance"].to_f,
                                       watson_language_master_id: watson_language_master.id)
          end
        end
      end
      yokyu_denpyo_parent = YokyuDenpyo.create(content: kakunin_params['sentence_origin'][i], 
                                     user_id: current_user.id, 
                                     yokyu_parent_id: yokyu_parent.id, 
                                     hospital: kakunin_params['hospital'].to_i,
                                     vendor: kakunin_params['vendor'].to_i,
                                     child: -1,
                                     parent: -1,
                                     file_manager_id: file_manager.id,
                                     watson_language_master_id: watson_language_master.id)
      answer = kakunin_params['sentence_answer'][i].split('█')
      (0..child_id.length-1).each do |j|
        if answer[j] !=""        
          yokyu_denpyo = YokyuDenpyo.create(content: answer[j], 
                             user_id: current_user.id, 
                             yokyu_parent_id: yokyu_parent.id, 
                             hospital: kakunin_params['hospital'].to_i,
                             vendor: kakunin_params['vendor'].to_i,
                             child: child_id[j],
                             parent: yokyu_denpyo_parent.id,
                             file_manager_id: file_manager.id,
                             watson_language_master_id: watson_language_master.id)
        end
      end
    end
    redirect_to shiyosho_path(:id => current_user, :paramkocok => @onaji)
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
    colfrom = sakusei_params["worksheetfrom"].to_i
    colto = sakusei_params["worksheetto"].to_i
    
    workbook = RubyXL::Parser.parse(filexls.path)
    ((colfrom-1)..(colto-1).to_i).each do |wsnum|
      worksheet=workbook[wsnum]
      #if sakusei_params["worksheetname"]!=""
      #  worksheet=workbook[sakusei_params["worksheetname"]]
      #end    
      
      #cell_value = worksheet[1][9].value
      #flash[:info] = workbook[0].sheet_name
      # redirect_to shiyosho_path(:id => current_user)
      
      (0..worksheet.count-1).each do |i|
        if worksheet[i][p_col] != nil
          if worksheet[i][p_col].value.to_s != "" 
            variant= worksheet[i][p_col].value.to_s.gsub(/。|、|\ |\.|,|　|\n/,'')
            watson_language_master = WatsonLanguageMaster.find_by(variant: variant)
            watson_parent_id=-1
            if watson_language_master!=nil
              if watson_language_master.anchor==-1
                watson_parent_id=watson_language_master.id
              else
                watson_parent_id=watson_language_master.anchor
              end
            end
            watson_language_variant = WatsonLanguageMaster.where("anchor=?",watson_parent_id)
            watson_variant_ids=Array.new(watson_language_variant.count+1)
            watson_variant_ids[0]=watson_parent_id    
            (1..watson_language_variant.count).each do |j|
              watson_variant_ids[j] = watson_language_variant[j-1].id
            end
            
            #get answer
            (0..child_id.length-1).each do |j|
              yokyu_denpyo_child = YokyuDenpyo.where("watson_language_master_id IN (?) AND child = ? AND user_id = ?", watson_variant_ids, child_id[j], current_user.id).first
              if worksheet[i][c_col[j]] == nil
                worksheet.add_cell(i, c_col[j] , yokyu_denpyo_child.content)
              else
                worksheet[i][c_col[j]].change_contents(yokyu_denpyo_child.content, worksheet[i][c_col[j]].formula)
              end

            end
            
            #write on cell
            #yokyu_denpyo_parent = YokyuDenpyo.where("content = ? AND parent = -1", worksheet[i][p_col].value.to_s).first
            #if yokyu_denpyo_parent != nil
            #  (0..child_id.length-1).each do |j|
            #    yokyu_denpyo_child = YokyuDenpyo.where("parent = ? AND child = ?", yokyu_denpyo_parent.id, child_id[j]).first
            #    if yokyu_denpyo_child.content != ""
            #      if worksheet[i][c_col[j]] == nil
            #        worksheet.add_cell(i, c_col[j] , yokyu_denpyo_child.content)
            #      else
            #        worksheet[i][c_col[j]].change_contents(yokyu_denpyo_child.content, worksheet[i][c_col[j]].formula)
            #        
            #      end
            #    end
            #  end
            #end
          end
        end
      end
    end
     #wsnum loop
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
    params.require(:sakusei).permit(:filename, :worksheetfrom, :worksheetto, :vendor, :hospital, :parent, :first_row, :child=>[], :child_id=>[])
  end
  
  def kakunin_params
    params.require(:kakunin).permit(:filexls_name, :hospital, :vendor, :child_id, :watson_parent_id=>[], :sentence_variant=>[], :sentence_origin=>[], :sentence_answer=>[], :onaji=>[], :watson_result=>[])
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
  
  def check_box_bug(param_checkbox)
    count_array=0
    result={}
    (0..param_checkbox.count-1).each do |i|
      if param_checkbox[i]=='1'
        count_array -= 1
        result[count_array]=1
        count_array += 1
      else
        result[count_array]=0
        count_array += 1
      
      end
      
    end
    
    return result
  end
  
end
