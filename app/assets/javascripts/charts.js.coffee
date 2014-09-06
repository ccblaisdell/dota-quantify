# Charts.coffee

da.charts = 
  performances: (url) ->
    window.kdaChart = dc.barChart('#kda-chart')
    window.outcomeChart = dc.pieChart('#outcome-chart')
    window.xpmChart = dc.barChart('#xpm-chart')

    # Fetch the data and do all the stuff
    d3.json url, (error, players) ->

      # Formatters for later use
      formatNumber = d3.format(',d')

      # Coerce data
      # players.forEach (d, i) -> d.kda_ratio = +d.kda_ratio

      # Create crossfilter groups and dimensions
      player = crossfilter(players)
      all = player.groupAll()

      kda = player.dimension (d) -> d.kda_ratio
      kdas = kda.group(Math.floor)
      
      outcome = player.dimension (d) -> d.outcome
      outcomes = outcome.group()
      
      xpm = player.dimension (d) -> d.xpm
      xpms = xpm.group (d) -> Math.floor(d / 50) * 50

      # xpm = kda
      # xpms = kdas

      # dc.barChart('#kda-chart')
      kdaChart_width = Math.floor(d3.max(players, (d) -> d.kda_ratio)) + 1
      kdaChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 30})
          .dimension(kda)
          .group(kdas)
          .elasticY(true)
          
          # Filter brush rounding
          .round(dc.round.floor)
          .alwaysUseRounding(true)
          
          .x(d3.scale.linear().domain([0, kdaChart_width]))

          # Customize the filter displayed in the control span
          .filterPrinter (filters) ->
            filter = filters[0]
            formatNumber(filter[0]) + " -> " + formatNumber(filter[1])

      # Customize axis
      # kdaChart.xAxis().tickFormat (v) -> v + "%"
      kdaChart.yAxis().ticks(5)

      #dc.barchart('#xpm-chart')
      xpmChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 30})
          .dimension(xpm)
          .group(xpms)
          .elasticY(true)
          .round (d) -> Math.floor(d / 50) * 50
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear()
              .domain([0, Math.ceil( d3.max(players, (d) -> d.xpm) / 50 ) * 50])
          )
          .xUnits -> 20

      xpmChart.yAxis().ticks(5)

      # dc.pieChart('#outcome-chart')
      outcomeChart.width(100)
          .height(100)
          .radius(40)
          .dimension(outcome)
          .group(outcomes)
          .renderLabel(true)


      dc.renderAll()