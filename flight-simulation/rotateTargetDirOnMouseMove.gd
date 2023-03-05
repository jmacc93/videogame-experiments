extends Node

onready var plane : Airplane = Lib.get_parent_with_class(self, Airplane)

export var rotation_rate = 1.0

func _input(event):
  if (event is InputEventMouseMotion) and Input.is_action_pressed("mouse_right"):
    var camera = get_viewport().get_camera()
    var cam_x_dir = Lib.to_global_vec(camera, Vector3(1, 0, 0)).normalized()
    var cam_y_dir = Lib.to_global_vec(camera, Vector3(0, 1, 0)).normalized()
    var cam_z_dir = Lib.to_global_vec(camera, Vector3(0, 0, -1)).normalized()
    plane.target_dir = plane.target_dir.rotated(cam_y_dir, -event.relative.x * rotation_rate)
    plane.target_dir = plane.target_dir.rotated(cam_x_dir, -event.relative.y * rotation_rate)
