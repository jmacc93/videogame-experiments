extends Spatial

onready var camera = find_node('Camera')
onready var crouch_point = find_node('crouchPoint')

func _process(delta):
  camera.translation = crouch_point.translation if Input.is_action_pressed("drop") else Vector3(0, 0, 0)
