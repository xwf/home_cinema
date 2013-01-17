search_form = $('#movie_search_form')
search_input = search_form.find('#movie_search_input')
movie_change_button = $('#movie_change_button')

setMovie = (data, textStatus, jqXHR) ->
  $('.modal').modal 'hide'
  search_form.hide()
  $('.movie-wrapper').html data.movie
  movie_change_button.show()
  $('#movie_suggestion_movie_id').val data.movie_id  
  activateReadMoreLinks()
  
movie_change_button.on 'click', ->
  if $('.moviepilot-link').length == 0
    $('#movie_form_modal').modal('show')
  else
    $('#movie_suggestion_movie_id').val ''
    $('.movie-wrapper').empty()
    movie_change_button.hide()
    search_form.show()
    search_input.focus()

## Movie Search ##

getMovie = (id) ->
  $.ajax "/movies/#{id}",
    dataType: 'json'
    success: setMovie

# auto-complete
search_input.on 'railsAutocomplete.select', (event, data) ->
  if data.item.show_all?
    search_form.submit()
  else if data.item.id?
    getMovie data.item.id

# search form and modal
search_modal = $('#search_modal')
search_nav = search_modal.find('#search_nav')
search_header = search_modal.find('#search_header')
search_results = search_modal.find('#search_results')
loader = search_modal.find('.loader')

searchSuccess = (data) ->
  # update modal content
  search_results.html data.results
  # activate movie select buttons
  search_results.find('button.movie-select').on 'click', (event) ->
    getMovie $(event.target).attr('data-id')
  # unless modal is already initialized
  unless search_modal.is '.initialized'
    # write modal title
    search_header.html data.header
    # build page navigation
    search_nav.html data.navigation
    activateNavLinks()
    # add initialized class
    search_modal.addClass 'initialized'

searchError = (error) ->
  search_results.html error.responseText
  search_nav.empty()
  switch error.status
    when 300, 404
      search_header.text "Keine Ergebnisse für '#{search_modal.query}'"
      search_results.find('a.suggestion-link').on 'click', (event) -> loadContent event.target.text
    when 500
      search_header.text 'Fehler'

# search form submission
search_form.on 'ajax:before', (event, xhr, settings) ->
  search_modal.query = search_input.val()
  if $.trim(search_modal.query).length >= 2
    search_header.html "Lade Ergebnisse f&uuml;r '#{search_modal.query}'&hellip;"
    search_modal.modal 'show'
  else
    #TODO: show error
    return false

search_form.on 'ajax:success', (xhr, data, status) -> searchSuccess(data)
search_form.on 'ajax:error', (xhr, error, status) -> searchError(error)

# search modal
search_modal.on 'hidden', ->
  search_nav.empty()
  search_header.empty()
  search_results.empty()
  search_results.append loader
  search_modal.removeClass 'initialized'
  search_input.val ''
  search_input.focus()

loadContent = (query, page=1) ->
  # show loader
  search_results.empty()
  search_results.append loader
  # update 'global' query var
  search_modal.query = query
  # send search query
  $.ajax '/movies/search',
    dataType: 'json'
    data:
      query: query
      page: page
    success: searchSuccess
    error: searchError

updateNav = (new_page, current_page) ->
  # update active element
  search_nav.find('li.active').removeClass 'active'
  search_nav.find("#page#{new_page}").addClass 'active'
  # center navigation to selected page
  prev = search_nav.find('#prev')
  next = search_nav.find('#next')
  page_elements = search_nav.find('li').not($(prev).add(next))
  page_count = page_elements.size()
  max_page = min(max(new_page + 4, 9), page_count)
  min_page = max(1, max_page - 8)
  visible_elements = page_elements.slice(min_page - 1, max_page)
  hidden_elements = page_elements.not visible_elements
  visible_elements.show()
  hidden_elements.hide()
  # enable or disable prev/next elements
  if new_page == 1 then prev.addClass 'disabled' else prev.removeClass 'disabled'
  if new_page == page_count then next.addClass 'disabled' else next.removeClass 'disabled'

activateNavLinks = ->
  nav_links = search_nav.find('a')
  nav_links.on 'click', (event) ->
    link = $(event.target)
    element = link.parent()
    unless element.is '.disabled, .active'
      page = getNewPage element.attr('id')
      updateNav page
      loadContent search_modal.query, page

getNewPage = (pageString) ->
  active_element = search_nav.find('li.active')
  current_page = parseInt active_element.attr('id').substring(4)
  switch pageString
    when 'prev' then current_page - 1
    when 'next' then current_page + 1
    else parseInt pageString.substring(4)

# manual movie form
form = $('#movie_form')
submit = form.find('#movie_submit')

movieFormError = (jqXHR, textStatus, errorThrown) ->
  response = $.parseJSON jqXHR.responseText
  for field_name, errors of response
    field_name = 'poster' if field_name.match /^poster_/
    field = form.find("#movie_#{field_name}")
    field.parents('.control-group').addClass 'error'
    field.parent().append $('<span/>').addClass('help-inline error').text(errors[0])
  selectFirstErrorField()

movieFormCleanup = (jqXHR, textStatus) ->
  submit.button 'reset'

selectFirstErrorField = ->
  $('.control-group.error:first :input').focus().select().size() > 0

form.on 'submit', ->
  return false if selectFirstErrorField()
  submit.button 'loading'
  fileInput = form.find '#movie_poster'
  if fileInput.val() == ''
    $.ajax form.attr('action'),
      type: 'POST'
      data: form.serialize()
      dataType: 'json'
      success: setMovie
      error: movieFormError
      complete: movieFormCleanup
  else
    form.fileupload 'add',
      fileInput: fileInput
  return false
  
form.fileupload
  dataType: 'json'
  dropZone: null
  fileInput: null
  done: (event, data) -> setMovie(data.result)
  fail: (event, data) -> movieFormError(data.jqXHR, data.textStatus, data.errorThrown)
  always: movieFormCleanup

form.find(':input').on 'change', ->
  $(this).parents('.control-group.error').removeClass 'error'
  $(this).siblings('.error').remove()
  
$('#movie_form_toggle').on 'click', ->
  form[0].reset()
