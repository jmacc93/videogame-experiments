extends Node

export var disabled = false

var parent : Spatial

export var target_spatial_path : NodePath
var target_spatial : Spatial

var initial_offset = Vector3(0, 0, 0)

export var x_axis = true
export var y_axis = true
export var z_axis = true
var axis_vector = Vector3(1, 1, 1)

func _ready():
  parent = get_parent()
  while not (parent is Spatial):
    parent = parent.get_parent()

  assert(parent and (parent is Spatial), 'No parent spatial found')

  assert(target_spatial_path, 'No target spatial given')
  target_spatial = get_node(target_spatial_path)
  assert(target_spatial, 'Target not found')

  initial_offset = parent.global_translation - target_spatial.global_translation
  axis_vector = Vector3( 1 if x_axis else 0,    1 if y_axis else 0,    1 if z_axis else 0  )


func _process(delta):
  if not disabled:
    var current_offset = parent.global_translation - target_spatial.global_translation
    parent.global_translation += initial_offset * axis_vector - current_offset * axis_vector

