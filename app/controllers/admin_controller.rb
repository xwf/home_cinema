
class AdminController < ApplicationController
  def index
		@shows = Show.where('date >= ?', DateTime.current)
  end
end
