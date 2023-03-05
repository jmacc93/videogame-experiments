extends Node

onready var spatial : Spatial = get_parent()
onready var player : KinematicBody = spatial.get_parent()

onready var camera : Camera = player.find_node("Camera")
onready var initial_position   = camera.to_local(spatial.to_global(Vector3(0, 0, 0)))
onready var initial_z_position = camera.to_local(spatial.to_global(Vector3(0, 0, 1)))

var velocity = Vector3(0, 0, 0)
var rotational_velocity = Vector3(0, 0, 0)

export var acceleration_mag = 1.0
export var velocity_decay = 0.1

func _process(delta):
  var target_position   = spatial.to_local(camera.to_global(initial_position))
  var target_z_position = spatial.to_local(camera.to_global(initial_z_position))
  var target_z_dir = (target_z_position - target_position).normalize()
  var target_z_rotation = camera.rotation
  
#  velocity += acceleration_mag * (initial_cam_offset - current_offset) * delta - velocity * pow(velocity_decay, delta)
  velocity += acceleration_mag * target_position * delta - velocity * velocity_decay * delta
  rotational_velocity
  
  spatial.translation += velocity * delta
  
