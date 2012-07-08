window.search_modal = $('#search_modal')
window.search_nav = search_modal.find('#search_nav')
window.search_header = search_modal.find('#search_header')
window.search_results = search_modal.find('#search_results')
window.loader = search_modal.find('.loader')
window.movie_search_form = $('#movie_search_form')
window.search_input = movie_search_form.find('#movie_search_query')
window.search_input_control_group = search_input.parents('.control-group')

search_input.on 'railsAutocomplete.select', (event, data) ->
  #

search_input.on 'autocompletesearch', (event, ui) ->
  search_input_control_group.removeClass 'error'
  search_input_control_group.find('.help-inline').remove()

movie_search_form.on 'ajax:before', (event, xhr, settings) ->
  query = search_input.val()
  if $.trim(query).length >= 2
    search_header.html "Lade Ergebnisse f&uuml;r '#{query}'&hellip;"
    search_modal.modal 'show'
  else    
    unless search_input_control_group.hasClass 'error'
      search_input_control_group.addClass 'error'
      search_input_control_group.find('.controls').append '<span class="help-inline">Bitte mindestens 2 Zeichen eingeben!</span>'
    search_input.focus()
    return false

search_modal.on 'hidden', ->
  search_nav.empty()
  search_header.empty()
  search_results.empty()
  search_results.append loader
  search_modal.removeClass 'initialized'

getPage = (pageString) ->
  active_element = search_nav.find('li.active')
  current_page = parseInt active_element.children().attr('href').substring(1)
  switch pageString
    when 'prev' then current_page - 1
    when 'next' then current_page + 1
    else parseInt pageString

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
  
loadContent = (page) ->
  # show loader
  search_results.empty()
  search_results.append loader
  # send query
  query = search_input.val()
  $.getScript "/movies/search?query=#{query}&page=#{page}"

window.activateNavLinks = ->
  nav_links = search_nav.find('a')
  nav_links.on 'click', (event) ->
    link = $(event.target)
    element = link.parent()
    unless element.is '.disabled, .active'
      page = getPage(link.attr('href').substring(1))
      updateNav page 
      loadContent page
  
