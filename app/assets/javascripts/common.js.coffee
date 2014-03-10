# Common js

da.watchFindForm = ->
  $('.fetch_form').submit (e) ->
    e.preventDefault()
    document.location.pathname += "/#{ $(this).find('input[type=search]').val() }"
    false
