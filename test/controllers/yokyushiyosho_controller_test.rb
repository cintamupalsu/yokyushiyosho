require 'test_helper'

class YokyushiyoshoControllerTest < ActionDispatch::IntegrationTest
  test "should get torikumi" do
    get yokyushiyosho_torikumi_url
    assert_response :success
  end

  test "should get sakusei" do
    get yokyushiyosho_sakusei_url
    assert_response :success
  end

end
