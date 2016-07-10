ready = ->
  if $('#users_show').length > 0
    $('.add-skill').click ->
      skill = prompt("What skill would you like added to your profile? ")
      if !!skill
        $(this).attr("href", $(this).attr("href").replace("PLACEHOLDER", encodeURIComponent(skill)))
      return !!skill

    selection_start = null
    own = $('.calendar').data('own')

    slot = (date, slot) ->
      $('[data-date=' + date + '][data-slot=' + slot + ']')

    admissible = (st, slot) ->
      st_status = $(st).data("status")
      slot_status = $(slot).data("status")

      if own
        if st_status == "unavailable"
          return true
        else if st_status == "available"
          return slot_status != "reserved"
      else
        return slot_status == "available"

    acceptable = (st) ->
      st_status = $(st).data("status")

      if own
        return st_status != "reserved"
      else
        return st_status == "available"

    fetch_blocks = (st, ed) ->
      if $(st).data("date") != $(ed).data("date")
        return []

      date = $(st).data("date")
      a = parseInt($(st).data("slot"))
      b = parseInt($(ed).data("slot"))

      results = []

      for i in [a..b]
        s = slot(date, i)

        if admissible(selection_start, s)
          results.push(s)
        else
          return []

      return results

    commit_blocks = (blocks) ->
      return if blocks.length == 0

      date = $(blocks[0]).data("date")
      st = parseInt($(blocks[0]).data("slot"))
      ed = parseInt($(blocks[blocks.length - 1]).data("slot"))

      st_status = $(blocks[0]).data("status")
      ed_status = $(blocks[blocks.length - 1]).data("status")
      action = null

      if own
        if st_status == 'available'
          action = "unavailable"
        else
          action = "available"
      else
        if st_status == 'available'
          action = "reserved"

      $('#mark_calendar_form input[name=date]').val(date)
      $('#mark_calendar_form input[name=st]').val(st)
      $('#mark_calendar_form input[name=ed]').val(ed)
      $('#mark_calendar_form input[name=mark_as]').val(action)

      $('#mark_calendar_form').submit()

    $(document).click '.calendar td.selectable', (e) ->
      return unless acceptable(e.target)

      if !selection_start
        selection_start = e.target
      else
        blocks = fetch_blocks(selection_start, e.target)
        commit_blocks(blocks)
        selection_start = null

    $(document).mouseover '.calendar td.selectable', (e) ->
      blocks = fetch_blocks(selection_start, e.target)

      $('.calendar .selected').removeClass('selected')
      for b in blocks
        $(b).addClass('selected')


$(document).on('turbolinks:load', ready)
