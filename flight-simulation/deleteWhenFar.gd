extends Node

export var distance_target_path : NodePath
onready var distance_target : Spatial = get_node(distance_target_path) as Spatial

onready var parent : Spatial = get_parent() as Spatial

export var max_distance = 10.0

func _on_deleteWhenFar_timeout():
  print('deleteWhenFar trying ')
  if distance_target and parent:
    var distance = (distance_target.global_translation - parent.global_translation).length()
    if distance >= max_distance:
      print('Deleting parent: ', parent, ' distance: ', distance)
      parent.queue_free()
