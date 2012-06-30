module ShowsHelper
	def submit_text
		if @show.new_record? then 'Weiter' else 'Speichern' end
	end
end
