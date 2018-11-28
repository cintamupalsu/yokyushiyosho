require 'test_helper'

class FileManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get file_managers_index_url
    assert_response :success
  end

  test "should get new" do
    get file_managers_new_url
    assert_response :success
  end

  test "should get edit" do
    get file_managers_edit_url
    assert_response :success
  end

  test "should get show" do
    get file_managers_show_url
    assert_response :success
  end

end
