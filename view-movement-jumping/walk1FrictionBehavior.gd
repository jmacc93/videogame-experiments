extends Node


onready var player = $'../..'

onready var touching_ground = $"../..".touching_ground
onready var hor_velocity = $"../..".hor_velocity
onready var velocity = $"../..".velocity
onready var traveling = $"..".traveling
onready var walking = $"..".walking
onready var last_walking_dir = $"..".last_walking_dir

var fric_on

export(float, 0, 100) var friction_magnitude = 1
export(float, 0, 100) var min_friction_speed = .2
export(float, 0, 100) var friction_unit_speed = 1
export var friction_curve : Curve

var lib = preload('lib.gd')

func _process(delta):
  fric_on = true
  
  if touching_ground and traveling and fric_on:
    var fric_accel : Vector3
    if walking:
      fric_accel = -lib.vec_rej(hor_velocity.normalized(), last_walking_dir)
      lib.drawline(player.translation, player.translation + fric_accel)
    else:
      fric_accel = -hor_velocity.normalized()
    velocity += delta * fric_accel * friction_curve.interpolate(hor_velocity.length() / friction_unit_speed) * friction_magnitude
#    label.set_text(String(hor_velocity.dot(last_walking_dir)))
    if not walking and hor_velocity.length() < min_friction_speed:
      velocity.x = 0
      velocity.z = 0
      traveling = false
