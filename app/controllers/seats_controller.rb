
class SeatsController < ApplicationController
  # GET /seats
  # GET /seats.json
  def index
  end

  # GET /seats/1
  # GET /seats/1.json
  def show
    @seat = Seat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seat }
    end
  end

  # GET /seats/new
  # GET /seats/new.json
  def new
    @seat = Seat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seat }
    end
  end

  # GET /seats/1/edit
  def edit
    @seat = Seat.find(params[:id])
  end

  # POST /seats
  # POST /seats.json
  def create
    @seat = Seat.new(params[:seat])
		filename = @seat.image.original_filename
		@seat.name = File.basename(filename, File.extname(filename)).humanize

    if @seat.save
			render json: {
				id: @seat.id,
				html: render_to_string(@seat, formats: :html)
			}
    else
			render json: @seat.errors, status: :unprocessable_entity
		end
  end

  # PUT /seats/1
  # PUT /seats/1.json
  def update
    for seat in Seat.all
			seat_data = params[seat.id.to_s]
			if seat_data
				seat.update_attributes(seat_data)
			else
				seat.destroy
			end
		end

		#TODO: error handling
    render json: {sucess: true}
  end

  # DELETE /seats/1
  # DELETE /seats/1.json
  def destroy
    @seat = Seat.find(params[:id])
    @seat.destroy

    respond_to do |format|
      format.html { redirect_to seats_url }
      format.json { head :no_content }
    end
  end
end
