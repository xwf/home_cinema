
class ShowsController < ApplicationController
  # GET /shows
  def index
    @shows = Show.where('date >= ?', DateTime.current)
		@admin = false
  end

  # GET /shows/1
  def show
    @show = Show.find(params[:id])
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
  end

  # POST /shows
  def create
    @show = Show.new(params[:show])
    if @show.save
			redirect_to admin_url, notice: 'Show was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /shows/1
  def update
    @show = Show.find(params[:id])
    if @show.update_attributes(params[:show])
			redirect_to admin_url, notice: 'Show was successfully updated.'
    else
			render action: "edit"
    end
  end

  # DELETE /shows/1
  def destroy
    @show = Show.find(params[:id])
    @show.destroy
    redirect_to admin_url
  end
end
