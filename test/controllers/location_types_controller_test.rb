require 'test_helper'

class LocationTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location_type = location_types(:one)
  end

  test "should get index" do
    get location_types_url, as: :json
    assert_response :success
  end

  test "should create location_type" do
    assert_difference('LocationType.count') do
      post location_types_url, params: { location_type: { name: @location_type.name } }, as: :json
    end

    assert_response 201
  end

  test "should show location_type" do
    get location_type_url(@location_type), as: :json
    assert_response :success
  end

  test "should update location_type" do
    patch location_type_url(@location_type), params: { location_type: { name: @location_type.name } }, as: :json
    assert_response 200
  end

  test "should destroy location_type" do
    assert_difference('LocationType.count', -1) do
      delete location_type_url(@location_type), as: :json
    end

    assert_response 204
  end
end
