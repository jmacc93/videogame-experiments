extends Node

onready var parent : Spatial = get_parent()

export var disabled = false

enum MouseAxis {X, Y}
export(MouseAxis) var mouse_axis = MouseAxis.X

enum RotationAxis {X, Y, Z}
export(RotationAxis) var rotation_multiplier_selection = RotationAxis.Y
var rotation_multiplier = Vector3(1, 0, 0)

func _ready():
  match rotation_multiplier_selection:
    RotationAxis.X:
      rotation_multiplier = Vector3(1, 0, 0)
    RotationAxis.Y:
      rotation_multiplier = Vector3(0, 1, 0)
    RotationAxis.Z:
      rotation_multiplier = Vector3(0, 0, 1)

var last_mouse_motion = Vector2(0, 0)

export var rotate_speed = 10

export(int, -1, 360) var max_angle = -1

func _input(event: InputEvent):
  var motion_event = event as InputEventMouseMotion
  if motion_event:
    last_mouse_motion = motion_event.relative

func _process(delta):
  if not disabled:
    
    var motion_value = 0.0
    match mouse_axis:
      MouseAxis.X:
        motion_value = last_mouse_motion.x
      MouseAxis.Y:
        motion_value = last_mouse_motion.y
    
    var current_angle
    if motion_value != 0:
      parent.rotation_degrees += -rotation_multiplier * motion_value * delta * rotate_speed
      if max_angle != -1:
        current_angle = parent.rotation_degrees.dot(rotation_multiplier)
        if abs(current_angle) > max_angle:
          parent.rotation_degrees += sign(current_angle) * max_angle * rotation_multiplier - parent.rotation_degrees * rotation_multiplier
    
    last_mouse_motion = Vector2(0, 0)
  







