require 'test_helper'

class PlayerControllerTest < ActionController::TestCase
  test "should get update" do
    get :update
    assert_response :success
  end

end
