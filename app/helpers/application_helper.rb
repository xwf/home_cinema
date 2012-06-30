module ApplicationHelper

	def pluralize_if_any(count, singular, plural)
		pluralize count, singular, plural if count > 0
	end

	def localize(*args)
		I18n.localize(*args) rescue ''
	end
	alias :l :localize

	def localize!(*args)
		I18n.localize(*args)
	end
	alias :l! :localize!

end
