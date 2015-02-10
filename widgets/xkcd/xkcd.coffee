class Dashing.Xkcd extends Dashing.Widget


    onData: (data) ->
        $el = $(this.node)

        # Remove the old image
        $el.find('img').remove()

        # Load the new image
        $img = $('<img src=' + data.image + '/>')
        $el.find('p').html(data.title)
        $el.append $img
