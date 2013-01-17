
class AdminController < ApplicationController
  def index
		@shows = Show.where('date >= ?', DateTime.current)
		@admin = true
  end
end
