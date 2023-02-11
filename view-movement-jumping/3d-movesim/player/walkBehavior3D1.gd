extends Node

onready var player = $'..'

var walking = false

export var can_always_walk = false

export(float, 0, 200) var move_rate = 26.0
export(float, 0, 3) var forward_walk_mult  = 1.0
export(float, 0, 3) var side_walk_mult     = 1.0
export(float, 0, 3) var backward_walk_mult = 1.0

var air_control_speed = 10
var air_control_walk_mag = 5

export var fric_mult = 15
export var walk_friction = 0.01
export var walk_above_move_rate_friction = 0.2
export var no_walk_friction = 0.1

var frames_touching_ground = 0
export var friction_begin_frames = 3

export var slow_speed_mag_cutoff_speed = 15
export(float, 0, 1) var slow_speed_mag_parameter = 0.2
export(float, 0, 1) var slow_speed_mag_min = 0.2

var slow_speed_mag = slow_speed_mag_min

var last_walk_vec = Vector3(0, 0, 0)

var walk_mod : float = 1.0
var jump_mod : float = 1.0
var friction_mod : float = 1.0

func _process(delta):
  
  var speed = player.hor_velocity.length()
  slow_speed_mag = slow_speed_mag_min + (1 - slow_speed_mag_min) * pow(min(speed, slow_speed_mag_cutoff_speed) / slow_speed_mag_cutoff_speed, slow_speed_mag_parameter)
  
  var walk_vec = Vector3(0, 0, 0)
  
  var player_speed_mod = player.speed_mod
  
  if Input.is_action_pressed("move_forward"):
    walk_vec +=  player.forward_dir * move_rate * forward_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_backward"):
    walk_vec += -player.forward_dir * move_rate * backward_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -player.rightward_dir * move_rate * side_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  player.rightward_dir * move_rate * side_walk_mult * player_speed_mod
  
  walk_vec *= walk_mod
  
  walking = walk_vec.length() > 0.001

  if player.touching_ground:
    if (frames_touching_ground > friction_begin_frames) and (walking or (player.velocity.length() > 0)):
      var fric_power = ((walk_above_move_rate_friction if (player.hor_velocity.length() > move_rate) else walk_friction) if walking else no_walk_friction) * 100 * friction_mod
      player.velocity = player.velocity +  fric_power * (walk_vec - player.hor_velocity) * delta
    else:
      frames_touching_ground += 1
  else:
    frames_touching_ground = 0
    if walking:
      var new_hor_vel = player.hor_velocity + air_control_walk_mag * walk_vec * delta
      var old_energy = player.hor_velocity.length_squared()
      var new_energy = new_hor_vel.length_squared()
      if (new_hor_vel.length() > move_rate) and (new_energy > old_energy):
        player.velocity = player.velocity + (player.hor_velocity.length() * new_hor_vel.normalized() - player.hor_velocity)
      else:
        player.velocity = player.velocity + (new_hor_vel - player.hor_velocity)
  
  last_walk_vec = walk_vec
  




