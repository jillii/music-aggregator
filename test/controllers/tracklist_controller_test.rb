require "test_helper"

class TracklistControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tracklist_index_url
    assert_response :success
  end

  test "should get new" do
    get tracklist_new_url
    assert_response :success
  end

  test "should get create" do
    get tracklist_create_url
    assert_response :success
  end

  test "should get edit" do
    get tracklist_edit_url
    assert_response :success
  end

  test "should get update" do
    get tracklist_update_url
    assert_response :success
  end

  test "should get destroy" do
    get tracklist_destroy_url
    assert_response :success
  end
end
