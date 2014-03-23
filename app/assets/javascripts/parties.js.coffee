# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
da.parties =
  initPartyTable: ->
    d3.json parties_url, (parties) ->
      table = d3.select '#parties'

      # Collect the column headers
      columns = d3.keys(parties[0]).filter (key) -> 
        key != 'id' && key != 'size'

      # Build missing table parts
      thead = table.append('thead')
      tbody = table.append('tbody')

      # build column headers
      headers = thead.append('tr').selectAll('th')
        .data(columns)
      .enter().append('th')
        # Attach click to sort handler
        .on 'click', (k) ->
          th = d3.select this
          is_desc = th.classed('sort-desc')

          # Remove all the triangles
          headers.classed('sort-asc sort-desc', false)

          # Set the class
          th.classed('sort-desc', !is_desc).classed('sort-asc', is_desc)

          # Sort!
          rows.sort (a,b) -> 
            # If sorting the profiles column, actually sort by Count
            return (if is_desc then a.size - b.size else b.size - a.size) if k == 'profile_ids'

            # Otherwise sort by the column value
            if is_desc then a[k] - b[k] else b[k] - a[k]
        .text columnHeaderText

      # build table rows
      rows = tbody.selectAll('tr')
        .data(parties)
      .enter().append('tr')

      # Build table cells
      cells = rows.selectAll('td')
        .data (row) -> 
          columns.map (column) ->
            {column: column, value: row[column]}
      .enter().append('td')
        .html (d) -> partyTableValue(d)

      table

    watchFilters()

# Private

# Format the table cell's html
partyTableValue = (cell) ->
  text = switch cell.column
    when "_id" then ''
    when "winrate" then d3.format('%') cell.value
    when "strict_winrate" then d3.format('%') cell.value
    when "url" then "<a href=\"#{cell.value}\">Show</a>"
    when "profile_ids"
      urls = []

      # loops through this party's profile_ids
      for _id in cell.value
        id = _id.$oid
        # collect the urls for profiles in this party
        profiles.forEach (profile) -> urls.push(profile.small_avatar_url) if profile._id.$oid == id

      # Collect the image tags
      images = urls.map (url) -> "<img src=\"#{url}\" class=\"avatar\">" unless url == null

      # Print them
      images.join(' ')

    else cell.value

  text

# Text for column header
columnHeaderText = (d) ->
  return "Members" if d == 'profile_ids'
  return "" if d == 'url'
  d

watchFilters = ->
  $filters = $ '#filters'

  $filters.on 'change', '#size', ->
    size = $(this).val()
    rows = d3.select('#parties tbody').selectAll('tr')
    return rows.style('display',null) if size == ''
    rows.style 'display', 'none'
      .filter (r) -> r.size == parseInt(size)
      .style 'display', null
