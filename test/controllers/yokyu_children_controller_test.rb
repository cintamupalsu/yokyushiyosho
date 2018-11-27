require 'test_helper'

class YokyuChildrenControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get yokyu_children_url
    assert_response :success
  end

  #test "should get new" do
  #  get yokyu_children_new_url
  #  assert_response :success
  #end

  #test "should get show" do
  #  get yokyu_children_show_url
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get yokyu_children_edit_url
  #  assert_response :success
  #end

end
