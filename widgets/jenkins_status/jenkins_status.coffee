class Dashing.JenkinsStatus extends Dashing.Widget
  ready: ->
    @_update()

  _duration: (span, digits) ->
    SECOND = 1000
    MINUTE = 60 * SECOND
    HOUR   = 60 * MINUTE
    DAY    = 24 * HOUR

    if ((days = span / DAY) && days > 1)
      days.toFixed(digits) + 'd'
    else if ((hours = span/HOUR) && hours > 1)
      hours.toFixed(digits) + 'h'
    else if ((minutes = span/MINUTE) && minutes > 1)
      minutes.toFixed(digits) + 'm'
    else
      seconds = span/SECOND
      seconds.toFixed(digits) + 's'

  _timeAgo: (time) ->
    @_duration(Date.now() - time)

  _extractAuthors: (authors) ->
    return "" unless authors
    return authors unless authors.match(/^pair\+/)
    authors.replace(/^pair\+/, '').split('+').join(' & ')

  _buildInfo: (build) ->
    {
      author: @_extractAuthors(build.change_author),
      comment: if build.change_comment then build.change_comment.split("\n")[0] else "(no changes)",
      duration: if build.building then "(building...)" else "(built in #{@_duration(build.duration, 1)})"
    }

  _updateWidget: (success) ->
    $el = $(@node)
    $el.removeClass('failure success')
    if success
      if $el.hasClass 'failure'
        @_playSuccessSound()
      $el.addClass('success')
    else
      if $el.hasClass 'success'
        @_playFailureSound()
      $el.addClass('failure')

  _update: ->
    return unless @timestamp?
    @set('updated', @_timeAgo(@.timestamp) + ' ago')
    if lastBuild = @.builds[0]
      @_updateWidget(lastBuild.success)
      @set('info', @_buildInfo(lastBuild))

  _playSuccessSound: ->
    new Howl({
      urls: ['success.mp3']
    }).play()

  _playFailureSound: ->
    new Howl({
      urls: ['failure.mp3']
    }).play()

  onData:  (data) ->
    @_update()
