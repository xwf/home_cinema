# update modal content
$('#search-modal #search-results').html "<%=j render partial: 'movies/search_result', collection: @response_data['movies'] %>"
# if modal is hidden
if $('#search-modal').is '.hide'
  # write modal title
  $('#search-modal #header').html "<%=j render 'movies/search_header' %>"
  # build page navigation
  #$('#search-modal #nav').html "<%=j render 'movies/search_navigation' %>"
  # show modal
  $('#search-modal').modal 'show'