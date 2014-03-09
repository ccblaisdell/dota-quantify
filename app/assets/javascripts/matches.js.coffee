# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

da.matches =
  watchFindMatch: ->
    console.log 'watch find match'
    $('#find_match').submit (e) ->
      e.preventDefault()
      console.log 'find_match submitted'
      document.location.pathname += "/#{ $('#match_id').val() }"
      false