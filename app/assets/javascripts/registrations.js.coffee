seat_plan = $('#seat_plan')

seat_plan.find('.seat').on 'mousedown', ->
  unless $(this).is 'taken'
    seat_plan.find('.selected').removeClass 'selected'
    $(this).addClass 'selected'