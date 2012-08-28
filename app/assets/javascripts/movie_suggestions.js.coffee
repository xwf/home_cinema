form = $('form#new_movie')
submit = form.find('#movie_submit')

success = (data, textStatus, jqXHR) ->
  $('#movie_form_modal').modal 'hide'
  $('#movie_wrapper').html data.movie
  $('#movie_suggestion_movie_id').val data.movie_id

error = (jqXHR, textStatus, errorThrown) ->
  response = $.parseJSON jqXHR.responseText
  for field_name, errors of response
    field = form.find("#movie_#{field_name}")
    field.parents('.control-group').addClass 'error'
    field.parent().append $('<span/>').addClass('help-inline error').text(errors[0])
  selectFirstErrorField()

cleanup = (jqXHR, textStatus) ->
  submit.removeAttr('disabled').val('Übernehmen')

selectFirstErrorField = ->
  $('.control-group.error:first :input').focus().select().size() > 0

form.fileupload
  dataType: 'json'
  dropZone: null
  fileInput: null
  done: (event, data) -> success(data.result)
  fail: (event, data) -> error(data.jqXHR, data.textStatus, data.errorThrown)
  always: cleanup

form.on 'submit', ->
  return false if selectFirstErrorField()
  submit.attr('disabled', 'disabled').val('Senden…')
  fileInput = form.find '#movie_poster'
  if fileInput.val() == ''
    $.ajax
      type: 'POST'
      url: form.attr('action')
      data: form.serialize()
      dataType: 'json'
      success: success
      error: error
      complete: cleanup
  else
    form.fileupload 'add',
      fileInput: fileInput
  return false
  
form.find(':input').on 'change', ->
  $(this).parents('.control-group.error').removeClass 'error'
  $(this).siblings('.error').remove()