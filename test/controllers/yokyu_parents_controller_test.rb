require 'test_helper'

class YokyuParentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get yokyu_parents_index_url
    assert_response :success
  end

  test "should get new" do
    get yokyu_parents_new_url
    assert_response :success
  end

  test "should get show" do
    get yokyu_parents_show_url
    assert_response :success
  end

  test "should get edit" do
    get yokyu_parents_edit_url
    assert_response :success
  end

end
