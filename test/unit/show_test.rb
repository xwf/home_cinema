require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  test 'date must be in the future' do
		show = Show.new(date: '2012-02-26 19:00:00')
		assert show.invalid?, 'Show should not be valid'
		assert_equal I18n.t('future'), show.errors[:date].join('; ')

		assert !show.update_attributes(date: Date.current), 'Update should fail'
		assert_equal I18n.t('future'), show.errors[:date].join('; ')
	end

	test 'date must be present' do
		show = Show.new
		assert show.invalid?, 'Show should not be valid'
		assert show.errors[:date].any?
	end
end
