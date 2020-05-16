require 'test_helper'

class CourtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @court = courts(:one)
  end

  test "should get index" do
    get courts_url, as: :json
    assert_response :success
  end

  test "should create court" do
    assert_difference('Court.count') do
      post courts_url, params: { court: { index: @court.index, name: @court.name } }, as: :json
    end

    assert_response 201
  end

  test "should show court" do
    get court_url(@court), as: :json
    assert_response :success
  end

  test "should update court" do
    patch court_url(@court), params: { court: { index: @court.index, name: @court.name } }, as: :json
    assert_response 200
  end

  test "should destroy court" do
    assert_difference('Court.count', -1) do
      delete court_url(@court), as: :json
    end

    assert_response 204
  end
end
