extends Node

export var track_point_path : NodePath
onready var track_point : Spatial = get_node(track_point_path)

func _physics_process(delta):
  if Input.is_action_pressed("mouse_left") and track_point:
    var camera = get_viewport().get_camera()
    var screen_click_point = get_viewport().get_mouse_position()
    var click_point = camera.project_ray_origin(screen_click_point) + camera.project_ray_normal(screen_click_point) * 1000
    track_point.global_translation = click_point
