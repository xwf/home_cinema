module ApplicationHelper

	def pluralize_if_any(count, singular, plural)
		pluralize count, singular, plural if count > 0
	end

end
