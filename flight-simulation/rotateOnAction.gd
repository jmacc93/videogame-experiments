extends Node

export var disable = false

onready var parent = get_parent()

export var action : String = ''

export(float, -180, 180) var max_angle = 45.0

export(float, 0, 1) var convergence_rate = 0.2

enum RotationAxis {X, Y, Z}
export(RotationAxis) var rotation_multiplier_selection = RotationAxis.Y
var rotation_multiplier = Vector3(1, 0, 0)

onready var initial_rotation = parent.rotation_degrees


func _ready():
  match rotation_multiplier_selection:
    RotationAxis.X:
      rotation_multiplier = Vector3(1, 0, 0)
    RotationAxis.Y:
      rotation_multiplier = Vector3(0, 1, 0)
    RotationAxis.Z:
      rotation_multiplier = Vector3(0, 0, 1)


func _process(delta):
  if action == '':
    return
  
  if disable:
    return
  
  var goal_angle = max_angle if Input.is_action_pressed(action) else 0.0
  var current_angle = parent.rotation_degrees.dot(rotation_multiplier)
  current_angle = current_angle + (goal_angle - current_angle) * convergence_rate
  
  parent.rotation_degrees = initial_rotation + current_angle * rotation_multiplier






