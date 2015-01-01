# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

da.matches =
  drawCalendar: (url) ->

    width = 960
    height = 136
    cellSize = 17 # cell size

    day = d3.time.format("%w")
    week = d3.time.format("%U")
    format = d3.time.format("%Y-%m-%d")
    data = {}

    color = d3.scale.quantize()
      .domain([0,11])
      .range d3.range(5).map((d) -> "q" + d + "-5")

    monthPath = (t0) ->
      t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0)
      d0 = +day(t0)
      w0 = +week(t0)
      d1 = +day(t1)
      w1 = +week(t1)
      "M" + (w0 + 1) * cellSize + "," + d0 * cellSize + "H" + w0 * cellSize + "V" + 7 * cellSize + "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize + "H" + (w1 + 1) * cellSize + "V" + 0 + "H" + (w0 + 1) * cellSize + "Z"

    # Create an svg for each year in the range
    svg = d3.select("body").selectAll("svg")
        .data(d3.range(2013, 2016))
      .enter().append("svg")
        .attr("width", width)
        .attr("height", height)
        .attr("class", "Blues")
      .append("g")
        .attr("transform", "translate(" + ((width - cellSize * 53) / 2) + "," + (height - cellSize * 7 - 1) + ")")

    svg.append("text")
        .attr("transform", "translate(-6," + cellSize * 3.5 + ")rotate(-90)")
        .style("text-anchor", "middle")
        .text (d) -> d

    rect = svg.selectAll(".day")
        .data (d) -> d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1))
      .enter().append("rect")
        .attr("class", "day")
        .attr("width", cellSize)
        .attr("height", cellSize)
        .attr("x", (d) -> week(d) * cellSize )
        .attr("y", (d) -> day(d) * cellSize )
        .datum(format)
        .on 'click', (d) -> window.location = data[d].url

    rect.append("title")
      .text (d) -> d

    svg.selectAll(".month")
        .data( (d) -> d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)) )
      .enter().append("path")
        .attr("class", "month")
        .attr("d", monthPath)

    d3.json url, (error, json) ->
      data = d3.nest()
        .key (d) -> d.day
        .rollup (matches) ->
          { 
            count: matches.length
            wins: d3.sum matches, (d) -> if d.won then 1 else 0
            url: matches[0].url
          }
        .map(json)

      color.domain [0, d3.max(Object.keys(data), (key) ->
        data[key].count
      )]

      rect.filter((d) -> d of data)
        .attr "class", (d) -> "day " + color(data[d].count)
        .select("title")
        .text (d) -> d + ": " + data[d].wins + "/" + data[d].count

    d3.select(self.frameElement).style("height", "2910px")

  loadListings: (url) ->
    $.ajax
      url: url
      success: (data) -> $('#matches').html(data)
