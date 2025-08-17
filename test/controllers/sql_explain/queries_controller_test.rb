require "test_helper"

module SqlExplain
  class QueriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get show" do
      get queries_show_url
      assert_response :success
    end
  end
end
