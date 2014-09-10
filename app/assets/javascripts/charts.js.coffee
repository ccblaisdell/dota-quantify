# Charts.coffee

da.charts = 
  performances: (url) ->
    window.kdaChart = dc.barChart('#kda-chart')
    window.outcomeChart = dc.pieChart('#outcome-chart')
    window.xpmChart = dc.barChart('#xpm-chart')
    window.gpmChart = dc.barChart('#gpm-chart')
    window.durationChart = dc.barChart('#duration-chart')
    window.volumeChart = dc.barChart('#volume-chart')
    window.heroesChart = document.getElementById('heroes-filter')

    # Do not throttle brush events
    dc.constants.EVENT_DELAY = 0

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
      # kdas = kda.group (d) -> Math.pow(2, Math.floor(Math.log(d)/Math.log(2)))
      kdas = kda.group (d) -> Math.pow(Math.sqrt(2), Math.round(Math.log(d)/Math.log(Math.sqrt(2))))
      
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

      hero = player.dimension (d) -> d.hero_id
      heroes = hero.group().reduceCount (d) -> d.hero_id
      window.hero = hero

      # dc.barChart('#kda-chart')
      kdaChart_width = Math.ceil(d3.max(players, (d) -> d.kda_ratio))
      kdaChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(kda)
          .group(kdas)
          .elasticY(true)
          .x(
            d3.scale.log()
              .domain([0.1, kdaChart_width])
              .base(2)
          )
          .xUnits -> kdas.size()
          .centerBar(true)
          .transitionDuration(100)

          # Customize the filter displayed in the control span
          .filterPrinter (filters) ->
            filter = filters[0]
            formatNumber(filter[0]) + " -> " + formatNumber(filter[1])

      # Customize axis
      kdaChart.xAxis().tickFormat (d) -> kdaChart.x().tickFormat(5, ",g.2")(d)
      kdaChart.yAxis().ticks(5)

      #dc.barchart('#xpm-chart')
      xpmChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(xpm)
          .group(xpms)
          .elasticY(true)
          .round (d) -> Math.floor(d / 50) * 50
          .alwaysUseRounding(true)
          .x(d3.scale.linear().domain([0, Math.ceil( d3.max(players, (d) -> d.xpm) / 50 ) * 50]))
          .xUnits -> xpmChart.x().domain()[1] / 50
          .transitionDuration(100)
      xpmChart.yAxis().ticks(5)

      #dc.barchart('#gpm-chart')
      gpmChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(gpm)
          .group(gpms)
          .elasticY(true)
          .round (d) -> Math.floor(d / 50) * 50
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear()
              .domain([
                0,
                Math.ceil( d3.max(players, (d) -> d.gpm) / 50 ) * 50
              ])
          )
          .xUnits -> gpmChart.x().domain()[1] / 50
          .transitionDuration(100)
      gpmChart.yAxis().ticks(5)

      #dc.barchart('#duration-chart')
      durationChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(duration)
          .group(durations)
          .elasticY(true)
          .round (d) -> Math.floor(d / 5) * 5
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear().nice()
              .domain([
                0,
                Math.ceil( d3.max(players, (d) -> d.duration) / 60 )
              ]).nice()
          )
          .xUnits -> durationChart.x().domain()[1] / 5 # durations.size()
          .transitionDuration(100)
      durationChart.yAxis().ticks(5)

      volumeChart.width(820)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(week)
          .group(weeks)
          .elasticY(true)
          .round(d3.time.week.round)
          .alwaysUseRounding(true)
          .x(d3.time.scale().domain(d3.extent(players, (d) -> d.start)))
          .xUnits(d3.time.weeks)
          .transitionDuration(100)
      volumeChart.yAxis().ticks(5)

      # dc.pieChart('#outcome-chart')
      outcomeChart.width(100)
          .height(100)
          .radius(40)
          .dimension(outcome)
          .group(outcomes)
          .renderLabel(true)
          .transitionDuration(100)

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
            ((d) -> React.renderComponentToString( PlayerOutcome({outcome: d.outcome, url: d.url}), this)),
            ((d) -> React.renderComponentToString( HeroAvatar({hero_id: d.hero_id}), this) + " " + d.name ),
            ((d) -> React.renderComponentToString( MatchDuration({duration: d.duration}), this) ),
            ((d) -> d.date),
            ((d) -> d.kills),
            ((d) -> d.deaths),
            ((d) -> d.assists),
            ((d) -> d.gpm),
            ((d) -> d.xpm)
          ])
          .sortBy (d) -> d.date
          .order d3.descending

      React.renderComponent( HeroesWidget({heroes: heroes.top(Infinity)}), heroesChart )

      dc.renderAll()