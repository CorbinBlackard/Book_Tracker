require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get authors_show_url
    assert_response :success
  end
end
