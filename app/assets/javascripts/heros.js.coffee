# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

da.heroes = 
  KDAHistogram: (el, url) ->
    d3.json url, (error, players) ->

      # Various formatters
      formatNumber = d3.format(',d')

      # A nest operator for grouping the players
      nestByDKA = d3.nest().key (d) -> d.kda_ratio

      # Force kda ratios to floats
      players.forEach (d, i) -> d.kda_ratio = +d.kda_ratio

      # Create the crossfilter for the relative dimensions and groups
      player = crossfilter(players)
      all = player.groupAll()
      kda = player.dimension (d) -> d.kda_ratio
      kdas = kda.group(Math.floor) # Not sure what function to group by, here

      # Renders the specified chart or list
      render = (method) -> d3.select(this).call(method)

      # Whenever the brush event moves, re-render everything
      renderAll = -> 
        chart.each(render)
        list.each(render)
        d3.select('#active').text(formatNumber(all.value()))

      window.filter = (filters) ->
        filters.forEach (d, i) -> charts[i].filter(d)
        renderAll()

      window.reset = (i) ->
        charts[i].filter null
        renderAll()

      playerList = (div) ->
        console.log 'render player list'

      barChart = ->
        barChart.id = 0 unless barChart.id

        margin = {top: 10, right: 10, bottom: 20, left: 10}
        y = d3.scale.linear().range([100, 0])
        id = barChart.id++
        axis = d3.svg.axis().orient("bottom")
        brush = d3.svg.brush()
        x = brushDirty = dimension = group = round = null

        chart = (div) ->
          width = x.range()[1]
          height = y.range()[0]

          y.domain([0, group.top(1)[0].value])

          barPath = (groups) ->
            console.log groups
            path = []
            i = -1
            n = groups.length

            while ++i < n
              d = groups[i]
              path.push("M", x(d.key), ",", height, "V", y(d.value), "h9V", height)

            path.join('')

          resizePath = (d) ->
            e = +(d == "e")
            _x = e ? 1 : -1
            _y = height / 3

            "M" + (.5 * _x) + "," + _y + "A6,6 0 0 " + e + " " + (6.5 * _x) + "," + (_y + 6) + "V" + (2 * _y - 6) + "A6,6 0 0 " + e + " " + (.5 * _x) + "," + (2 * _y) + "Z" + "M" + (2.5 * _x) + "," + (_y + 8) + "V" + (2 * _y - 8) + "M" + (4.5 * _x) + "," + (_y + 8) + "V" + (2 * _y - 8)

          div.each ->
            div = d3.select(this)
            g = div.select('g')

            # Create the skeletal chart
            if g.empty()
              div.select('title').append('a')
                  .attr("href", "javascript:reset(" + id + ")")
                  .attr("class", "reset")
                  .text("reset")
                  .style("display", "none")

              g = div.append("svg")
                  .attr("width", width + margin.left + margin.right)
                  .attr("height", height + margin.top + margin.bottom)
                .append("g")
                  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

              g.append("clipPath")
                  .attr("id", "clip-" + id)
                .append("rect")
                  .attr("width", width)
                  .attr("height", height)

              g.selectAll(".bar")
                  .data(["background", "foreground"])
                .enter().append("path")
                  .attr("class", (d) -> d + " bar")
                  .datum(group.all())

              g.selectAll(".foreground.bar")
                  .attr("clip-path", "url(#clip-" + id + ")")

              g.append("g")
                  .attr("class", "axis")
                  .attr("transform", "translate(0," + height + ")")
                  .call(axis)

              # Initialize the brush component with pretty resize handles.
              gBrush = g.append("g").attr("class", "brush").call(brush)
              gBrush.selectAll("rect").attr("height", height)
              gBrush.selectAll(".resize").append("path").attr("d", resizePath)

            # End if g.empty()

            # Only redraw the brush if set externally.
            if brushDirty
              brushDirty = false
              g.selectAll(".brush").call(brush)
              div.select(".title a").style("display", if brush.empty() then "none" else null)
              if brush.empty()
                g.selectAll("#clip-" + id + " rect")
                    .attr("x", 0)
                    .attr("width", width)
              else
                extent = brush.extent()
                g.selectAll("#clip-" + id + " rect")
                    .attr("x", x(extent[0]))
                    .attr("width", x(extent[1]) - x(extent[0]))
            # End if brushDirty

            g.selectAll(".bar").attr("d", barPath)

          # End div.each

        # end chart = (div) ->

        brush.on 'brushstart.chart', ->
          div = d3.select(this.parentNode.parentNode.parentNode)
          div.select(".title a").style("display", null)

        brush.on 'brush.chart', ->
          g = d3.select(this.parentNode)
          extent = brush.extent()
          
          if (round) 
            g.select(".brush")
                .call(brush.extent(extent = extent.map(round)))
              .selectAll(".resize")
                .style("display", null)

          g.select("#clip-" + id + " rect")
              .attr("x", x(extent[0]))
              .attr("width", x(extent[1]) - x(extent[0]))
          dimension.filterRange(extent)

        brush.on 'brushend.chart', ->
          if brush.empty()
            div = d3.select(this.parentNode.parentNode.parentNode)
            div.select(".title a").style("display", "none")
            div.select("#clip-" + id + " rect").attr("x", null).attr("width", "100%")
            dimension.filterAll()

        chart.margin = (_) ->
          return margin unless arguments.length
          margin = _
          chart

        chart.x = (_) ->
          return x unless arguments.length
          x = _
          axis.scale(x)
          brush.x(x)
          chart

        chart.y = (_) ->
          return y unless arguments.length
          y = _
          chart

        chart.dimension = (_) ->
          return dimension unless arguments.length
          dimension = _
          chart

        chart.filter = (_) ->
          if _
            brush.extent(_)
            dimension.filterRange(_)
          else
            brush.clear()
            dimension.filterAll()
          brushDirty = true
          chart

        chart.group = (_) ->
          return group unless arguments.length
          group = _
          chart

        chart.round = (_) ->
          return round unless arguments.length
          round = _
          chart

        d3.rebind(chart, brush, "on")
      # end BarChart



      charts = [
        barChart()
            .dimension(kda)
            .group(kdas)
          .x(d3.scale.linear()
            .domain([0,          Math.floor(d3.max(players, (d) -> d.kda_ratio)) * 2])
            .rangeRound([0, 10 * Math.floor(d3.max(players, (d) -> d.kda_ratio)) * 2]))
      ]

      # Given our array of charts, which we assume are in the same order as the
      # .chart elements in the DOM, bind the charts to the DOM and render thmm.
      # We also listen to the charts' brush events to update the display.
      chart = d3.selectAll('.chart')
          .data(charts)
          .each (chart) -> chart.on("brush", renderAll).on("brushend", renderAll)

      # Render the initial lists
      list = d3.selectAll('.list')
          .data([playerList])

      # Render the total
      d3.selectAll('#total')
          .text(formatNumber(player.size()))

      renderAll()
