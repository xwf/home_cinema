class Seat < ActiveRecord::Base
  attr_accessible :image_path_free, :image_path_selected, :image_path_taken,
									:name, :position_x, :position_y

	has_many :seat_reservations, dependent: :destroy

	validates :name, presence: true, uniqueness: {case_sensitive: false}
end
