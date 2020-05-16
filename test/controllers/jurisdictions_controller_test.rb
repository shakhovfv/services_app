require 'test_helper'

class JurisdictionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jurisdiction = jurisdictions(:one)
  end

  test "should get index" do
    get jurisdictions_url, as: :json
    assert_response :success
  end

  test "should create jurisdiction" do
    assert_difference('Jurisdiction.count') do
      post jurisdictions_url, params: { jurisdiction: { District_id: @jurisdiction.District_id, address: @jurisdiction.address, email: @jurisdiction.email, judge_fio: @jurisdiction.judge_fio, phone: @jurisdiction.phone, reseption_of_citizens: @jurisdiction.reseption_of_citizens, sector: @jurisdiction.sector, work_time: @jurisdiction.work_time } }, as: :json
    end

    assert_response 201
  end

  test "should show jurisdiction" do
    get jurisdiction_url(@jurisdiction), as: :json
    assert_response :success
  end

  test "should update jurisdiction" do
    patch jurisdiction_url(@jurisdiction), params: { jurisdiction: { District_id: @jurisdiction.District_id, address: @jurisdiction.address, email: @jurisdiction.email, judge_fio: @jurisdiction.judge_fio, phone: @jurisdiction.phone, reseption_of_citizens: @jurisdiction.reseption_of_citizens, sector: @jurisdiction.sector, work_time: @jurisdiction.work_time } }, as: :json
    assert_response 200
  end

  test "should destroy jurisdiction" do
    assert_difference('Jurisdiction.count', -1) do
      delete jurisdiction_url(@jurisdiction), as: :json
    end

    assert_response 204
  end
end
