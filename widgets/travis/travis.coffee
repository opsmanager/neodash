class Dashing.Travis extends Dashing.Widget
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
    return authors unless authors.match(/@neo.com/)
    authors.replace(/^pair\+/, '').replace(/\@.*/,'').split('+').join(' & ')

  _buildInfo: (build) ->
    {
      author: @_extractAuthors(build.change_author),
      comment: if build.change_comment then build.change_comment.split("\n")[0] else "(no changes)",
      duration: if !build.duration? then "(building...)" else "(built in #{@_duration(build.duration * 1000, 1)})"
    }

  _update: ->
    if lastBuild = @.builds[0]
      console.debug(lastBuild.timestamp, new Date(lastBuild.timestamp), @_timeAgo(new Date(lastBuild.timestamp)))

      if lastBuild.timestamp? && !isNaN(@_timeAgo(new Date(lastBuild.timestamp)))
        @set('updated', @_timeAgo(new Date(lastBuild.timestamp)) + ' ago')

      @_checkStatus(lastBuild.success)
      @set('info', @_buildInfo(lastBuild))

  onData:  (data) ->
    @_update()

  _checkStatus: (status) ->
    $(@node).removeClass('errored failed passed started')
    $(@node).addClass(status)
