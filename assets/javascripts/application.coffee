# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js
#= require moment.min
#= require moment-timezone.min
#= require moment-timezone-data
#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [350, 200]
  Dashing.numColumns ||= 4

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    Dashing.gridsterLayout('[

        {"col":1,"row":1,"size_x":1,"size_y":2},
        {"col":2,"row":1,"size_x":1,"size_y":2},
        {"col":3,"row":1,"size_x":1,"size_y":2},
        {"col":4,"row":1,"size_x":1,"size_y":4},
        {"col":1,"row":3,"size_x":3,"size_y":2}]')


    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions

