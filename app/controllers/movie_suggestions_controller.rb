class MovieSuggestionsController < ApplicationController

	before_filter :init

	# GET /movie_suggestions
  # GET /movie_suggestions.json
  def index		
    @movie_suggestions = @show.movie_suggestions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movie_suggestions }
    end
  end

  # GET /movie_suggestions/1
  # GET /movie_suggestions/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie_suggestion }
    end
  end

  # GET /movie_suggestions/new
  # GET /movie_suggestions/new.json
  def new
		@movie_suggestion = @show.movie_suggestions.build(movie_id: params[:movie_id])
		@movie = @movie_suggestion.movie || Movie.new
		
    respond_to do |format|
			format.js
      format.html # new.html.erb
    end
  end

  # GET /movie_suggestions/1/edit
  def edit
    @movie = @movie_suggestion.movie
  end

  # POST /movie_suggestions
  # POST /movie_suggestions.json
  def create
		@movie_suggestion = @show.movie_suggestions.build(params[:movie_suggestion])
		@movie_suggestion.status = @registration ? Status::PENDING : Status::ACCEPTED

    respond_to do |format|
      if @movie_suggestion.save
        format.html { redirect_to @return_url, notice: I18n::t('notice.suggestion.created') }
      else
        format.html do
					flash_errors
					@movie = @movie_suggestion.movie || Movie.new
					render action: "new"
				end
      end
    end
  end

  # PUT /movie_suggestions/1
  # PUT /movie_suggestions/1.json
  def update
		respond_to do |format|
      if @movie_suggestion.update_attributes(params[:movie_suggestion])
        format.html { redirect_to @return_url, notice: I18n::t('notice.suggestion.updated') }
      else
        format.html do
					flash_errors
					@movie = @movie_suggestion.movie
					render action: "edit"
				end
      end
    end
  end

  # DELETE /movie_suggestions/1
  # DELETE /movie_suggestions/1.json
  def destroy
    @movie_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to @return_url, notice: I18n::t('notice.suggestion.deleted') }
    end
  end

	protected
	def init

		if params[:registration_id]
			begin
				@registration = Registration.find_by_code!(params[:registration_id])
				@movie_suggestion = @registration.movie_suggestion
				@show = @registration.show
				@return_url = registration_url(@registration)
				@form_path = registration_movie_suggestion_path(@registration.code)
				unless @movie_suggestion || ['new', 'create'].include?(action_name)
					logger.error("Attempt to modify non-existing movie suggestion for registration ##{params[:registration_id]}")
					redirect_to @return_url, alert: I18n::t('alert.suggestion.not_found')
				end
			rescue ActiveRecord::RecordNotFound
				logger.error("Attempt to access invalid registration ##{params[:registration_id]}")
				redirect_to shows_url, alert: I18n::t('alert.registration.invalid_code')
			end
		else
			check_admin
			if params[:id]
				begin
					@movie_suggestion = MovieSuggestion.find(params[:id])
					@show = @movie_suggestion.show
					@form_path = movie_suggestion_path(@movie_suggestion)
				rescue ActiveRecord::RecordNotFound
					logger.error("Attempt to access invalid movie suggestion ##{params[:id]}")
					redirect_to admin_url, alert: I18n::t('alert.suggestion.not_found')
				end
			elsif params[:show_id]
				begin
					@show = Show.find(params[:show_id])
					@form_path = show_movie_suggestions_path(@show)
				rescue ActiveRecord::RecordNotFound
					logger.error("Attempt to access invalid show ##{params[:show_id]}")
					redirect_to admin_url, alert: I18n::t('alert.show.not_found')
				end
			end
			@return_url = show_movie_suggestions_url(@show)
		end
	end

	def flash_errors
		flash.now[:error] = @movie_suggestion.errors.values.join('<br/>')
	end

end
