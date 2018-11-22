class YokyushiyoshoController < ApplicationController
  before_action :logged_in_user
  
  def create_torikomi
  end

  def create_sakusei
    yokyu = sakusei_params
    filexls = yokyu['filename']
    workbook = RubyXL::Parser.parse(filexls.path)
    worksheet = workbook[0]
    cell_value = worksheet[0][0].value
    @sakusei = filexls.original_filename
    worksheet.add_cell(1, 1 ,"Text B2")
    workbook.write(filexls.path)
    #send_data(filexls, :type => 'application/excel', :filename => filexls.original_filename)
    send_data( workbook.stream.read, :disposition => 'attachment', :type => 'application/excel', :filename => "filexls.original_filename")
    #send_data(filexls)
  end

  def sakusei
     @user = User.find(current_user.id)
  end
  
  private
  # Parameters protection
  def sakusei_params
    params.require(:sakusei).permit(:filename, :detail, :answer, :remark)
  end
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end  
  
  
end
