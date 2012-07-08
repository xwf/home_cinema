# update modal content
search_results.html "<%=j render partial: 'movies/search_result', collection: @response_data['movies'] %>"
# if modal is hidden
unless search_modal.hasClass 'initialized'
  # write modal title
  search_header.html "<%=j render 'movies/search_header' %>"
  # build page navigation
  search_nav.html "<%=j render 'movies/search_navigation' %>"
  activateNavLinks()
  # add initialized class
  search_modal.addClass 'initialized'