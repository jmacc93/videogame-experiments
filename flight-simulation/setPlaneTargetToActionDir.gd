extends Node

onready var plane : Airplane = Lib.get_parent_with_class(self, Airplane)

func _input(event):
  var camera = get_viewport().get_camera()
  var cam_x_dir = Lib.to_global_vec(camera, Vector3(1, 0, 0))
  var cam_y_dir = Lib.to_global_vec(camera, Vector3(0, 1, 0))
  var cam_z_dir = Lib.to_global_vec(camera, Vector3(0, 0, -1))
  var horizontal_z = cam_z_dir
  horizontal_z.y = 0
  horizontal_z = horizontal_z.normalized()
  if Input.is_action_just_pressed("set_target_to_up"):
    print(cam_x_dir, ' ', cam_y_dir, ' ', cam_z_dir, ' ')
    plane.target_dir = Vector3(0, 1, 0)
  elif Input.is_action_just_pressed("set_target_to_down"):
    plane.target_dir = Vector3(0, -1, 0)
  elif Input.is_action_just_pressed("set_target_to_left"):
    plane.target_dir = -cam_x_dir
  elif Input.is_action_just_pressed("set_target_to_right"):
    plane.target_dir = cam_x_dir
  elif Input.is_action_just_pressed("set_target_to_forward"):
    plane.target_dir = horizontal_z
  elif Input.is_action_just_pressed("set_target_to_backward"):
    plane.target_dir = -horizontal_z
