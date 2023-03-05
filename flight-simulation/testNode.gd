tool
extends Node

export var radius = 10.0

var parent : Spatial
var registered_global_translation


func _enter_tree():
  print('process set')
  parent = get_parent()
  registered_global_translation = parent.global_translation
  set_process(true)


func update_radius(indicator_circle):
  indicator_circle.radius = radius
  indicator_circle.global_translation = registered_global_translation


func _process(delta):
  if parent and parent.global_translation != registered_global_translation:
    var indicator_circle = get_node_or_null('indicatorCircle')
    if not indicator_circle:
      indicator_circle = CSGSphere.new()
      self.add_child(indicator_circle)
    update_radius(indicator_circle)
    registered_global_translation = parent.global_translation
    pass
