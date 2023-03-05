extends Node

onready var player = $'..'

var walking = false

var last_walking_dir : float

export var can_always_walk = false

export(float, 0, 200) var move_rate = 40
export(float, 0, 3) var backward_walk_mult = 1.0

export var air_control_walk_mag = 8.0

export var fric_mult = 10
export var auto_friction = 0.4

var lib = preload('res://lib.gd')

var frames_touching_ground = 0
export var friction_begin_frames = 5

func lint(a, b, u):
  return a + (b - a) * u

var x_dir = Vector2(1, 0)
var y_dir = Vector2(0, -1)

var walk_vec

func set_debug_point(vec: Vector2):
  var circle : Sprite = $"../debugPoint/Sprite"
  var debug_point : Node2D = $"../debugPoint"
  circle.global_position = debug_point.global_position + vec

func _process(delta):
  var draw_scale = 0.1
  
  walk_vec = 0
  set_debug_point(Vector2(0, 0))
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -move_rate * 10
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  move_rate * 10
  
  
  walking = abs(walk_vec) > 0.001

  last_walking_dir = sign(walk_vec)
  if player.touching_ground:
    if (frames_touching_ground > friction_begin_frames):
      var fric_power = auto_friction * 100
      player.velocity = player.velocity + Vector2(fric_power * (walk_vec - player.hor_velocity) * delta, 0)
      if abs(player.hor_velocity) < 1:
        player.velocity = Vector2(0, player.velocity.y)
    else:
      frames_touching_ground += 1
  else:
    frames_touching_ground = 0
  
  if (not player.touching_ground) and walking:
    var new_hor_vel = player.hor_velocity + air_control_walk_mag * walk_vec * delta
    var old_energy = abs(player.hor_velocity)
    var new_energy = abs(new_hor_vel)
    if (abs(new_hor_vel) > move_rate * 10) and (new_energy > old_energy):
      player.velocity = player.velocity + Vector2(abs(player.hor_velocity) * new_hor_vel / abs(new_hor_vel) - player.hor_velocity, 0)
    else:
      player.velocity = player.velocity + Vector2(new_hor_vel - player.hor_velocity, 0)
    
    
