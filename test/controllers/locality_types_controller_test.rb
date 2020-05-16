require 'test_helper'

class LocalityTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @locality_type = locality_types(:one)
  end

  test "should get index" do
    get locality_types_url, as: :json
    assert_response :success
  end

  test "should create locality_type" do
    assert_difference('LocalityType.count') do
      post locality_types_url, params: { locality_type: { name: @locality_type.name } }, as: :json
    end

    assert_response 201
  end

  test "should show locality_type" do
    get locality_type_url(@locality_type), as: :json
    assert_response :success
  end

  test "should update locality_type" do
    patch locality_type_url(@locality_type), params: { locality_type: { name: @locality_type.name } }, as: :json
    assert_response 200
  end

  test "should destroy locality_type" do
    assert_difference('LocalityType.count', -1) do
      delete locality_type_url(@locality_type), as: :json
    end

    assert_response 204
  end
end
