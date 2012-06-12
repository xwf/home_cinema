require 'test_helper'

class MovieSuggestionsControllerTest < ActionController::TestCase
  setup do
    @movie_suggestion = movie_suggestions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_suggestions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie_suggestion" do
    assert_difference('MovieSuggestion.count') do
      post :create, movie_suggestion: { comment: @movie_suggestion.comment, movie_id: @movie_suggestion.movie_id, registration_id: @movie_suggestion.registration_id, show_id: @movie_suggestion.show_id }
    end

    assert_redirected_to movie_suggestion_path(assigns(:movie_suggestion))
  end

  test "should show movie_suggestion" do
    get :show, id: @movie_suggestion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie_suggestion
    assert_response :success
  end

  test "should update movie_suggestion" do
    put :update, id: @movie_suggestion, movie_suggestion: { comment: @movie_suggestion.comment, movie_id: @movie_suggestion.movie_id, registration_id: @movie_suggestion.registration_id, show_id: @movie_suggestion.show_id }
    assert_redirected_to movie_suggestion_path(assigns(:movie_suggestion))
  end

  test "should destroy movie_suggestion" do
    assert_difference('MovieSuggestion.count', -1) do
      delete :destroy, id: @movie_suggestion
    end

    assert_redirected_to movie_suggestions_path
  end
end
