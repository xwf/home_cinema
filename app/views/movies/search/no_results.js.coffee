search_header.text "Keine Ergebnisse für '<%= params['query'] %>'"
search_results.html "<%=j render partial: @suggestions.empty? ? 'movies/search/no_results' : 'movies/search/suggestions' %>"
search_results.find('a.suggestion-link').on 'click', (event) -> loadContent event.target.text