# Charts.coffee

da.charts = 
  handleError: (error) ->
    $('.spinner-container')
      .html("<p>Oops, the data didn't load! Refresh the page to try again.</p>")

  performances: (url) ->
    window.kdaChart = dc.barChart('#kda-chart')
    window.outcomeChart = dc.pieChart('#outcome-chart')
    window.xpmChart = dc.barChart('#xpm-chart')
    window.gpmChart = dc.barChart('#gpm-chart')
    window.durationChart = dc.barChart('#duration-chart')
    window.volumeChart = dc.barChart('#volume-chart')
    window.heroesChart = document.getElementById('heroes-filter')
    window.profilesChart = document.getElementById('names-filter')

    $('#data-count').on 'click', -> 
      $(document).trigger("filterAll")

    # Do not throttle brush events
    # dc.constants.EVENT_DELAY = 0

    # Fetch the data and do all the stuff
    d3.json url, (error, players) ->
      return da.charts.handleError(error) if error
      $('.spinner-container').remove()
      $('.hide').fadeIn()

      # Formatters for later use
      formatNumber = d3.format(',d')
      formatDate = d3.time.format("%m/%d/%Y")

      winReducer = (d) -> d.outcome == 'won'
      lossReducer = (d) -> d.outcome == 'lost'

      # Coerce data
      players.forEach (d, i) -> 
        d.start = new Date(d.adjusted_start)
        d.date = formatDate(d.start)
        d.week = d3.time.week(d.start) # Precalculate week for better performance

      # Create crossfilter groups and dimensions
      player = crossfilter(players)
      all = player.groupAll()

      kda = player.dimension (d) -> d.kda_ratio
      groupKDAs = (d) -> Math.pow(Math.sqrt(2), Math.round(Math.log(d)/Math.log(Math.sqrt(2))))
      kda_wins_group = kda.group(groupKDAs).reduceSum(winReducer)
      kda_losses_group = kda.group(groupKDAs).reduceSum(lossReducer)
      
      outcome = player.dimension (d) -> d.outcome
      outcomes = outcome.group()
      
      xpm = player.dimension (d) -> d.xpm
      groupXPMs = (d) -> Math.floor(d / 50) * 50
      xpm_wins_group = xpm.group(groupXPMs).reduceSum(winReducer)
      xpm_losses_group = xpm.group(groupXPMs).reduceSum(lossReducer)
      
      gpm = player.dimension (d) -> d.gpm
      groupGPMs = (d) -> Math.floor(d / 50) * 50
      gpm_wins_group = gpm.group(groupGPMs).reduceSum(winReducer)
      gpm_losses_group = gpm.group(groupGPMs).reduceSum(lossReducer)
      
      duration = player.dimension (d) -> d.duration / 60
      duration_bucket_division = 5
      duration_group_function = (d) -> Math.floor(d / duration_bucket_division) * duration_bucket_division
      duration_wins_group   = duration.group(duration_group_function).reduceSum(winReducer) 
      duration_losses_group = duration.group(duration_group_function).reduceSum(lossReducer)

      week = player.dimension (d) -> d.week
      weekly_wins_group = week.group().reduceSum(winReducer)
      weekly_losses_group = week.group().reduceSum(lossReducer)

      date = player.dimension (d) -> d.date

      hero = player.dimension (d) -> d.hero_id
      heroes = hero.group().reduceCount (d) -> d.hero_id
      window.hero = hero

      profile = player.dimension (d) -> d.name
      profiles = profile.group()
      window.profile = profile

      # dc.barChart('#kda-chart')
      kdaChart_width = Math.ceil(d3.max(players, (d) -> d.kda_ratio))
      kdaChart.width(400)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(kda)
          .group(kda_wins_group)
          .stack(kda_losses_group)
          .elasticY(true)
          .x(
            d3.scale.log()
              .domain([0.1, kdaChart_width])
              .base(2)
          )
          .xUnits -> kda_wins_group.size()
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
          .group(xpm_wins_group)
          .stack(xpm_losses_group)
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
          .group(gpm_wins_group)
          .stack(gpm_losses_group)
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
          .group(duration_wins_group)
          .stack(duration_losses_group)
          .elasticY(true)
          .round (d) -> Math.floor(d / duration_bucket_division) * duration_bucket_division
          .alwaysUseRounding(true)
          .x(
            d3.scale.linear().nice()
              .domain([
                0,
                Math.ceil( d3.max(players, (d) -> d.duration) / 60 )
              ]).nice()
          )
          .xUnits -> durationChart.x().domain()[1] / duration_bucket_division 
          .transitionDuration(100)
      durationChart.yAxis().ticks(5)

      volumeChart.width(820)
          .height(100)
          .margins({top: 10, right: 10, bottom: 20, left: 40})
          .dimension(week)
          .group(weekly_wins_group)
          .stack(weekly_losses_group)
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
            ((d) -> React.renderComponentToString( HeroAvatar({hero_id: d.hero_id, hero_avatar: d.hero_avatar}), this) + " " + d.name ),
            ((d) -> React.renderComponentToString( MatchDuration({duration: d.duration}), this) ),
            ((d) -> d.date),
            ((d) -> d.kills),
            ((d) -> d.deaths),
            ((d) -> d.assists),
            ((d) -> d.gpm),
            ((d) -> d.xpm)
          ])
          .sortBy (d) -> d.start.valueOf()
          .order d3.descending

      React.renderComponent( HeroesWidget({heroes: heroes.top(Infinity)}), heroesChart )
      React.renderComponent( NamesWidget({profiles: profiles.top(Infinity)}), profilesChart )

      dc.renderAll()