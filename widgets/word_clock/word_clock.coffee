class Dashing.WordClock extends Dashing.Widget

  startClock: ->
    angle = 360 / 60
    date = new timezoneJS.Date(new Date(), @location)
    hour = date.getHours() % 12
    minute = date.getMinutes()
    second = date.getSeconds()
    hourAngle = (360 / 12) * hour + (360 / (12 * 60)) * minute

    clock = document.querySelector("[data-location='" + @location + "']")

    ['-webkit-transform', '-moz-transform', '-o-transform', '-ms-transform', 'transform'].forEach (vendor) ->
      clock.querySelector(".minute").style[vendor] = "rotate(" + angle * minute + "deg)"
      clock.querySelector(".second").style[vendor] = "rotate(" + angle * second + "deg)"
      clock.querySelector(".hour").style[vendor] = "rotate(" + hourAngle + "deg)"

    document.querySelector('.clock').className += ' started'

  ready: ->
    @set('location', @location)
    @startClock()

  # onData: (data) ->
  #   # Handle incoming data
  #   # You can access the html node of this widget with `@node`
  #   # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
