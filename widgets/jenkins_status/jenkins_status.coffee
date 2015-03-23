class Dashing.JenkinsStatus extends Dashing.Widget
  ready: ->
    @_update()

  _duration: (span, digits) ->
    SECOND = 1000
    MINUTE = 60 * SECOND
    HOUR   = 60 * MINUTE
    DAY    = 24 * HOUR

    if ((days = span / DAY) && days > 1)
      days.toFixed(digits) + ' days'
    else if ((hours = span/HOUR) && hours > 1)
      hours.toFixed(digits) + ' hours'
    else if ((minutes = span/MINUTE) && minutes > 1)
      minutes.toFixed(digits) + ' mins'
    else
      seconds = span/SECOND
      seconds.toFixed(digits) + ' seconds'

  _timeAgo: (time) ->
    @_duration(Date.now() - time)

  _extractAuthors: (authors) ->
    return "" unless authors
    return authors unless authors.match(/^pair\+/)
    authors.replace(/^pair\+/, '').split('+').join(' & ')

  _buildInfo: (build) ->
    {
      author: @_extractAuthors(build.change_author),
      comment: if build.change_comment then build.change_comment.split("\n")[0] else "no changes",
      duration: if build.building then "building..." else "built in #{@_duration(build.duration, 1)}"
    }

  _updateWidget: (lastBuild) ->
    $el = $(@node)
    $el.removeClass('failure success building')
    if lastBuild.building
      $el.addClass 'building'
      return
    if lastBuild.success
      $el.addClass 'success'
    else
      $el.addClass 'failure'

  _update: ->
    return unless @timestamp?
    @set('updated', @_timeAgo(@.timestamp) + ' ago')
    if lastBuild = @.builds[0]
      @_updateWidget(lastBuild)
      @set('info', @_buildInfo(lastBuild))

  onData:  (data) ->
    console.log "data", data
    @_update()
