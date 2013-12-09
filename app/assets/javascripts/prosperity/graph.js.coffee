
class Graph
  constructor: (option) ->
    @url = option.url
    @el = option.el
    @$el = $(option.el)

  render: ->
    highchartsOptions = 
      chart:
        type: 'line'
        renderTo: @el
      tooltip:
        crosshairs: [true, true]
      series: []
      xAxis: 
        type: 'datetime'
        dateTimeLabelFormats:
          day: '%e of %b'
      yAxis: [{}, {}, {}]
      title: 
        text: "Loading..."

    chart = new Highcharts.Chart(highchartsOptions)

    getSeries = (url, axisIndex) =>
      $.get url, (json) =>
        serie = 
          data: json.data
          name: json.key
          yAxis: axisIndex
          pointStart: Date.parse(json.start_time)
          pointInterval: json.period_milliseconds

        axisSettings = 
          title: {text: json.key}
          min: Math.min.apply(Math, json.data)
          max: Math.max.apply(Math, json.data)
      

        if json.key == 'change'
          axisSettings = $.extend axisSettings, {
            min: 0,
            max: Math.max.apply(Math, json.data),
            labels: {formatter: -> this.value + '%' },
            opposite: true
          }

          serie = $.extend serie, {
            tooltip: {valueDecimals: 2, valueSuffix: '%'}
          }

        chart.yAxis[axisIndex].update(axisSettings)
        chart.addSeries(serie)

    $.getJSON @url, (json) ->
      chart.setTitle {text: json.title}

      for extractor, index in json.extractors
        getSeries(extractor.url, index)
        
    @
  
@Prosperity ||= {}
@Prosperity.Graph = Graph
