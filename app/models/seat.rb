class Seat < ActiveRecord::Base
  attr_accessible :image,	:name, :position_x, :position_y

	has_many :seat_reservations, dependent: :destroy
	has_attached_file :image,
										styles: { sized: 'x150' },
										path: ':rails_root/public/system/:class/:attachment/:id/:style/:filename',
										url: '/system/:class/:attachment/:id/:style/:filename'

	validates :name, presence: true, uniqueness: {case_sensitive: false}
	validates_attachment :image, presence: true, content_type: { content_type: /image\/[\w\-]*(?:jpe?g|png|gif)$/i }

end
