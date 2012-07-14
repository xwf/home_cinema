# update modal content
search_results.html "<%=j render partial: 'movies/search/result', collection: @movies %>"
# unless modal is already initialized
unless search_modal.hasClass 'initialized'
  # write modal title
  search_header.html "<%=j render 'movies/search/header' %>"
  # build page navigation
  search_nav.html "<%=j render 'movies/search/navigation' %>"
  activateNavLinks '<%=j params[:query] %>'
  # add initialized class
  search_modal.addClass 'initialized'