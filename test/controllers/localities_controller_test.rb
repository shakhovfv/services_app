require 'test_helper'

class LocalitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @locality = localities(:one)
  end

  test "should get index" do
    get localities_url, as: :json
    assert_response :success
  end

  test "should create locality" do
    assert_difference('Locality.count') do
      post localities_url, params: { locality: { LocalityType_id: @locality.LocalityType_id, name: @locality.name, parent_id: @locality.parent_id } }, as: :json
    end

    assert_response 201
  end

  test "should show locality" do
    get locality_url(@locality), as: :json
    assert_response :success
  end

  test "should update locality" do
    patch locality_url(@locality), params: { locality: { LocalityType_id: @locality.LocalityType_id, name: @locality.name, parent_id: @locality.parent_id } }, as: :json
    assert_response 200
  end

  test "should destroy locality" do
    assert_difference('Locality.count', -1) do
      delete locality_url(@locality), as: :json
    end

    assert_response 204
  end
end
