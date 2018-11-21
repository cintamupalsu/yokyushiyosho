require 'test_helper'

class YokyushiyoshoControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test "should get sakusei" do
    log_in_as(@user)
    get shiyosho_path
    assert_response :success
  end

end
