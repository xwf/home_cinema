
class MovieSuggestionsController < ApplicationController
  # GET /movie_suggestions
  # GET /movie_suggestions.json
  def index
    @movie_suggestions = MovieSuggestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movie_suggestions }
    end
  end

  # GET /movie_suggestions/1
  # GET /movie_suggestions/1.json
  def show
    @movie_suggestion = MovieSuggestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie_suggestion }
    end
  end

  # GET /movie_suggestions/new
  # GET /movie_suggestions/new.json
  def new
    @movie_suggestion = MovieSuggestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie_suggestion }
    end
  end

  # GET /movie_suggestions/1/edit
  def edit
    @movie_suggestion = MovieSuggestion.find(params[:id])
  end

  # POST /movie_suggestions
  # POST /movie_suggestions.json
  def create
    @movie_suggestion = MovieSuggestion.new(params[:movie_suggestion])

    respond_to do |format|
      if @movie_suggestion.save
        format.html { redirect_to @movie_suggestion, notice: 'Movie suggestion was successfully created.' }
        format.json { render json: @movie_suggestion, status: :created, location: @movie_suggestion }
      else
        format.html { render action: "new" }
        format.json { render json: @movie_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movie_suggestions/1
  # PUT /movie_suggestions/1.json
  def update
    @movie_suggestion = MovieSuggestion.find(params[:id])

    respond_to do |format|
      if @movie_suggestion.update_attributes(params[:movie_suggestion])
        format.html { redirect_to @movie_suggestion, notice: 'Movie suggestion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movie_suggestions/1
  # DELETE /movie_suggestions/1.json
  def destroy
    @movie_suggestion = MovieSuggestion.find(params[:id])
    @movie_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to movie_suggestions_url }
      format.json { head :no_content }
    end
  end
end
