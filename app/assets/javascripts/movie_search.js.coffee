this.search_modal = $('#search_modal')
this.search_nav = search_modal.find('#search_nav')
this.search_header = search_modal.find('#search_header')
this.search_results = search_modal.find('#search_results')
this.loader = search_modal.find('.loader')
this.search_form = $('#movie_search_form')
this.search_input = search_form.find('#movie_search_input')

search_input.on 'railsAutocomplete.select', (event, data) ->
  if data.item.show_all?
    search_form.submit()
  else if data.item.id?
    updateMovie data.item.id

search_form.on 'ajax:before', (event, xhr, settings) ->
  query = search_input.val()
  if $.trim(query).length >= 2
    search_header.html "Lade Ergebnisse f&uuml;r '#{query}'&hellip;"
    search_modal.modal 'show'
  else
    #TODO: show error
    return false

search_modal.on 'hidden', ->
  search_nav.empty()
  search_header.empty()
  search_results.empty()
  search_results.append loader
  search_modal.removeClass 'initialized'
  search_input.val ''
  search_input.focus()

getPage = (pageString) ->
  active_element = search_nav.find('li.active')
  current_page = parseInt active_element.attr('id').substring(4)
  switch pageString
    when 'prev' then current_page - 1
    when 'next' then current_page + 1
    else parseInt pageString.substring(4)

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

this.updateMovie = (movie_id) ->
  $.getScript '?movie_id=' + movie_id

this.loadContent = (query, page=1) ->
  # show loader
  search_results.empty()
  search_results.append loader
  # send query
  $.getScript "/movies/search?query=#{query}&page=#{page}"

this.activateNavLinks = (query) ->
  nav_links = search_nav.find('a')
  nav_links.on 'click', (event) ->
    link = $(event.target)
    element = link.parent()
    unless element.is '.disabled, .active'
      page = getPage element.attr('id')
      updateNav page
      loadContent query, page

