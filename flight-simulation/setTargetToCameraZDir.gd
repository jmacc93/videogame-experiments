extends Node

onready var parent_plane = Lib.get_parent_with_class(self, Airplane)

export var on_mouse_left = false

func _process(delta):
  if parent_plane and ((not on_mouse_left) or Input.is_action_pressed("mouse_left")):
    var camera = get_viewport().get_camera()
    parent_plane.target_dir = Lib.to_global_vec(camera, Vector3(0, 0, -1))

