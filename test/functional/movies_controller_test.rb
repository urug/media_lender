require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post :create, :movie => { }
    end

    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should show movie" do
    get :show, :id => movies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => movies(:one).to_param
    assert_response :success
  end

  test "should update movie" do
    put :update, :id => movies(:one).to_param, :movie => { }
    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete :destroy, :id => movies(:one).to_param
    end

    assert_redirected_to movies_path
  end
end
