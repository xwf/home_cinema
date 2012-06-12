require 'test_helper'

class SeatsControllerTest < ActionController::TestCase
  setup do
    @seat = seats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seat" do
    assert_difference('Seat.count') do
      post :create, seat: { image_path_free: @seat.image_path_free, image_path_selected: @seat.image_path_selected, image_path_taken: @seat.image_path_taken, name: @seat.name, position_x: @seat.position_x, position_y: @seat.position_y }
    end

    assert_redirected_to seat_path(assigns(:seat))
  end

  test "should show seat" do
    get :show, id: @seat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seat
    assert_response :success
  end

  test "should update seat" do
    put :update, id: @seat, seat: { image_path_free: @seat.image_path_free, image_path_selected: @seat.image_path_selected, image_path_taken: @seat.image_path_taken, name: @seat.name, position_x: @seat.position_x, position_y: @seat.position_y }
    assert_redirected_to seat_path(assigns(:seat))
  end

  test "should destroy seat" do
    assert_difference('Seat.count', -1) do
      delete :destroy, id: @seat
    end

    assert_redirected_to seats_path
  end
end
