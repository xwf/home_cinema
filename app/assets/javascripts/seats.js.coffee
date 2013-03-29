seat_plan = $('#seat_plan')
pos_x = $('#seat_position_x')
pos_y = $('#seat_position_y')
seat_name = $('#seat_name')
seat_info = $('#seat_info')

makeDraggable = (items) ->  
  $(items).draggable
    containment: 'parent'
    scroll: false
  .on 'drag mousedown', (event, ui) ->
    position = if ui? then ui.position else $(this).position()
    pos_x.val position.left
    pos_y.val position.top
  .on 'mousedown', ->
    seat_plan.find('.selected').removeClass 'selected'
    $(this).addClass 'selected ui-draggable-dragging'
    seat_name.val $(this).data('name')
    seat_info.show()
  .on 'mouseup', ->
    $(this).removeClass 'ui-draggable-dragging'
  
setPositionX = (value) ->
  selected = seat_plan.find('.seat.selected')
  if selected.length == 1
    pos_x.val min(max(0, parseInt(value)), seat_plan.width() - selected.width())
    selected.css 'left', pos_x.val() + 'px'

setPositionY = (value) ->
  selected = seat_plan.find('.seat.selected')
  if selected.length == 1 
    pos_y.val min(max(0, parseInt(value)), seat_plan.height() - selected.height())
    selected.css 'top', pos_y.val() + 'px'
  
makeDraggable seat_plan.find('.seat')

$(document).on 'keydown', (event) ->
  x = parseInt(pos_x.val())
  y = parseInt(pos_y.val())
  switch event.which
    when 37 then setPositionX(x - 1) # left
    when 39 then setPositionX(x + 1) # right
    when 38 then setPositionY(y - 1) # up
    when 40 then setPositionY(y + 1) # down
    when 36 then setPositionX(x - 10) # home
    when 35 then setPositionX(x + 10) # end
    when 33 then setPositionY(y - 10) # page up
    when 34 then setPositionY(y + 10) # page down
    else other_key = true

  event.preventDefault() unless other_key

seat_name.on 'keydown', (event) ->
  switch event.which
    when 37, 39 then event.stopPropagation()

pos_x.on 'change', -> setPositionX(pos_x.val())
pos_y.on 'change', -> setPositionY(pos_y.val())
  
seat_name.on 'keyup', ->
  seat_plan.find('.seat.selected').data('name', $(this).val())
  
$('#delete_seat').on 'click', ->
  seat_plan.find('.seat.selected').remove()
  seat_info.hide()

$('#seat_image').fileupload
  dataType: 'json'
  add: (e, data) ->
    data.submit()
  done: (e, data) ->
    $('#seat_plan').append data.result.html
    makeDraggable '#seat' + data.result.id
  
$('#save_seats_btn').on 'click', ->
  data = {}
  seat_plan.find('.seat').each ->
    seat_position = $(this).position()
    data[$(this).data('id')] =
      name: $(this).data 'name'
      position_x: seat_position.left
      position_y: seat_position.top
  $.ajax '/seats/all',
    type: 'PUT'
    data: data
    success: -> window.location.href = '/admin'
  

    