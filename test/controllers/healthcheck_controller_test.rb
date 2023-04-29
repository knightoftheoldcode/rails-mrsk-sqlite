require "test_helper"

class HealthcheckControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get healthcheck_show_url
    assert_response :success
  end
end
