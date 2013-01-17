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

	def first_words(string, n)
		return string.strip.concat(' <a class="read-less-link">Weniger anzeigen</a>').html_safe if n < 0
		words = string.strip.split(/[ ]+/)
		words[0...n].join(' ') + (words.size > n ? '... <a class="read-more-link">Weiterlesen</a>' : '')
	end

end
