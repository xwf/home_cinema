require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  setup do
		@reg = Registration.new(
			code: 'kfq7',
			name: 'Bill',
			email: 'bill@example.org',
			status: Registration::STATUS_PENDING,
			show: shows(:one)
		)
	end

	test 'registration must not be empty' do
		reg = Registration.new
		assert reg.invalid?
		assert reg.errors[:code].any?
		assert reg.errors[:name].any?
		assert reg.errors[:email].any?
		assert reg.errors[:status].any?
		assert reg.errors[:show].any?
	end

	test 'show must exist' do
		@reg.show = nil
		@reg.show_id = 12345
		assert @reg.invalid?
		assert @reg.errors[:show].any?
	end

	test 'code must be unique' do
		@reg.code = registrations(:joe).code
		assert !@reg.save
		assert @reg.errors[:code].any?
		#assert_equal I18n.translate('activerecord.errors.messages.taken'),
		#	@reg.errors[:code].join('; ')
	end

	test 'code must consist of 4 alphanumeric chars' do
		ok = %w{a3er 1234 aaaa}
		nok = %w{a5d a$23 a5rfx ar-t}

		ok.each do |code|
			@reg.code = code
			assert @reg.valid?, "#{code} should not be invalid"
		end

		nok.each do |code|
			@reg.code = code
			assert @reg.invalid?, "#{code} should not be valid"
			assert @reg.errors[:code].any?
		end
	end

	test 'name/email must be unique per show' do
		@reg.name = registrations(:joe).name
		@reg.email = registrations(:joe).email
		assert !@reg.save, 'Registration should not save'
		assert @reg.errors[:name].any?, 'Should have errors for name'
		#assert_equal I18n.translate('activerecord.errors.messages.taken'),
		#	@reg.errors[:name].join('; ')


		@reg.name = @reg.name.upcase
		assert !@reg.save, 'Registration should not save (UC name)'
		assert @reg.errors[:name].any?, 'Should have errors for name'
		#assert_equal I18n.translate('activerecord.errors.messages.taken'),
		#	@reg.errors[:name].join('; ')

		@reg.name = registrations(:joe).name
		@reg.email = registrations(:joe).email
		@reg.show = shows(:two)
		assert @reg.save, 'Registration should save'
	end

	test 'status must have one of the predefined values' do
		ok = Registration::STATUSES
		nok = %w{blub PENDING Accepted dEnIeD}

		ok.each do |status|
			@reg.status = status
			assert @reg.valid?, "#{status} should not be invalid"
		end

		nok.each do |status|
			@reg.status = status
			assert @reg.invalid?, "#{status} should not be valid"
			assert @reg.errors[:status].any?
		end
	end

	test 'maximal 2 seat reservations per registration' do
		@reg.show = shows(:two)

		@reg.seat_reservations.build(seat_id: seats(:one).id)
		assert @reg.save, "Registration should save with 1 seat reservation.\nErrors: #{@reg.errors.to_hash}"

		@reg.seat_reservations.build(seat_id: seats(:two).id)
		assert @reg.save, "Registration should save with 2 seat reservations.\nErrors: #{@reg.errors.to_hash}"

		@reg.seat_reservations.build(seat_id: seats(:three).id)
		assert !@reg.save, 'Registration should not save with 3 seat reservations'
		assert @reg.errors[:base].any?, 'An error should be present'
	end

	test 'seat reservations must be unique per show' do
		@reg.seat_reservations.build(seat_id: seats(:two).id)
		assert @reg.save

		@reg.seat_reservations.build(seat_id: seats(:one).id)
		assert !@reg.save
		assert @reg.errors[:base].any?, 'An error should be present'
	end

	test 'email format' do
		ok = %w{a@b.c abc.rtz@a2b-rtz.exy.pog a-b_c@dfg.hjk Bill.Gates@microsoft.com}
		nok = ['xaz ghj@abc.de', 'abc@def', 'abc@xyz@fgh.de', 'rtz&kjf@abc.ch']

		ok.each do |email|
			@reg.email = email
			assert @reg.valid?, "#{email} should not be invalid"
		end

		nok.each do |email|
			@reg.email = email
			assert @reg.invalid?, "#{email} should not be valid"
			assert @reg.errors[:email].any?
		end
	end



end
