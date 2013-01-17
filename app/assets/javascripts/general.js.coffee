this.max = Math.max;
this.min = Math.min;

# read more
this.activateReadMoreLinks = ->
  $('a.read-more-link').on 'click', ->
    $(this).parents('.read-more-short').hide().siblings('.read-more-full').show()

  $('a.read-less-link').on 'click', ->
    $(this).parents('.read-more-full').hide().siblings('.read-more-short').show()

activateReadMoreLinks()