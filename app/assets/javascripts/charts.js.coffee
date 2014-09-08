# Charts.coffee

da.charts = 
  performances: (url) ->
    window.kdaChart = dc.barChart('#kda-chart')
    window.outcomeChart = dc.pieChart('#outcome-chart')
    window.xpmChart = dc.barChart('#xpm-chart')
    window.gpmChart = dc.barChart('#gpm-chart')
    window.durationChart = dc.barChart('#duration-chart')
    window.volumeChart = dc.barChart('#volume-chart')

    # Fetch the data and do all the stuff
    d3.json url, (error, players) ->

      # Formatters for later use
      formatNumber = d3.format(',d')
      formatDate = d3.time.format("%m/%d/%Y")

      # Coerce data
      players.forEach (d, i) -> 
        d.start = new Date(d.adjusted_start)
        d.date = formatDate(d.start)
        d.week = d3.time.week(d.start) # Precalculate week for better performance

      # Create crossfilter groups and dimensions
      player = crossfilter(players)
      all = player.groupAll()

      kda = player.dimension (d) -> d.kda_ratio
      kdas = kda.group(Math.floor)
      
      outcome = player.dimension (d) -> d.outcome
      outcomes = outcome.group()
      
      xpm = player.dimension (d) -> d.xpm
      xpms = xpm.group (d) -> Math.floor(d / 50) * 50
      
      gpm = player.dimension (d) -> d.gpm
      gpms = gpm.group (d) -> Math.floor(d / 50) * 50
      
      duration = player.dimension (d) -> d.duration / 60
      durations = duration.group (d) -> Math.floor(d / 5) * 5

      week = player.dimension (d) -> d.week
      weeks = week.group()

      date = player.dimension (d) -> d.date
      # dates = date.group(d3.time.days)

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
          .xUnits -> xpms.size()
      xpmChart.yAxis().ticks(5)

      #dc.barchart('#gpm-chart')
      gpmChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 30})
          .dimension(gpm)
          .group(gpms)
          .elasticY(true)
          .round (d) -> Math.floor(d / 50) * 50
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear()
              .domain([
                Math.floor( d3.min(players, (d) -> d.gpm) / 50 ) * 50,
                Math.ceil( d3.max(players, (d) -> d.gpm) / 50 ) * 50
              ])
          )
          .xUnits -> gpms.size()
      gpmChart.yAxis().ticks(5)

      #dc.barchart('#duration-chart')
      durationChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 30})
          .dimension(duration)
          .group(durations)
          .elasticY(true)
          .round (d) -> Math.floor(d / 5) * 5
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear()
              .domain([
                0
                Math.ceil( d3.max(players, (d) -> d.duration) / 60 ) + 1
              ])
          )
          .xUnits -> durations.size()
      durationChart.yAxis().ticks(5)

      volumeChart.width(820)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 30})
          .dimension(week)
          .group(weeks)
          .elasticY(true)
          .round(d3.time.week.round)
          .alwaysUseRounding(true)
          .x(d3.time.scale().domain(d3.extent(players, (d) -> d.start)))
          .xUnits(d3.time.weeks)
      volumeChart.yAxis().ticks(5)

      # dc.pieChart('#outcome-chart')
      outcomeChart.width(100)
          .height(100)
          .radius(40)
          .dimension(outcome)
          .group(outcomes)
          .renderLabel(true)

      # Data count
      dc.dataCount('#data-count')
          .dimension(player)
          .group(all)
          .html({
            some: "<strong>%filter-count</strong> selected out of <strong>%total-count</strong> records | <a href='javascript:dc.filterAll(); dc.renderAll();'>Reset All</a>",
            all: "All records selected."
          })

      # The table at the bottom of the page
      dc.dataTable("#data-table")
          .dimension(date)
          .group (d) ->
            format = d3.format("02d")
            d.start.getFullYear() + "/" + format(d.start.getMonth() + 1)
          .columns([
            ((d) -> console.log(this); React.renderComponentToString(PlayerOutcome({outcome: d.outcome}), this)),
            ((d) -> Math.floor(d.duration / 60)),
            ((d) -> d.date),
            ((d) -> d.kills),
            ((d) -> d.deaths),
            ((d) -> d.assists),
            ((d) -> d.gpm),
            ((d) -> d.xpm)
          ])
          .sortBy (d) -> d.date
          .order d3.descending


      dc.renderAll()