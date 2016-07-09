ready = ->
  if $('#users_show').length > 0
    $('.add-skill').click ->
      skill = prompt("What skill would you like added to your profile? ")
      $(this).attr("href", $(this).attr("href").replace("PLACEHOLDER", encodeURIComponent(skill)))
      true

$(document).on('turbolinks:load', ready)
