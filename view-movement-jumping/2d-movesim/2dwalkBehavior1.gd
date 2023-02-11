extends Node

onready var player = $'..'

var walking = false

var last_walking_dir : float

export var can_always_walk = false
export var can_always_jump = false
export var autohop = false

export(float, 0, 100) var jump_force = 18
export(float, 0, 400) var jump_forward_force = 6

export(float, 0, 200) var move_rate = 26
export(float, 0, 3) var backward_walk_mult = 1.0

export var air_control_speed = 10
export var air_control_walk_mag = 30

export var fric_mult = 15
export var auto_friction = 0.1

export var jump_mouse_mult = 0.1
export var jump_mouse_side_mult = 3

var lib = preload('res://lib.gd')

var last_mouse_movement : Vector2

var frames_touching_ground = 0
export var friction_begin_frames = 3

func lint(a, b, u):
  return a + (b - a) * u

var did_jump = false

var x_dir = Vector2(1, 0)
var y_dir = Vector2(0, -1)

func _input(event):
    if event is InputEventMouseMotion:
        last_mouse_movement = event.relative

func set_debug_point(vec: Vector2):
  var circle : Sprite = $"../debugPoint/Sprite"
  var debug_point : Node2D = $"../debugPoint"
  circle.global_position = debug_point.global_position + vec

func _process(delta):
  var draw_scale = 0.1
  
  var walk_vec = 0
  set_debug_point(Vector2(0, 0))
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -move_rate * 10
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  move_rate * 10
  
  var autohop_condition = autohop and player.velocity.y < 0.1
  if Input.is_action_pressed("jump") and ((player.touching_ground and (not did_jump or autohop_condition)) or can_always_jump):
    player.velocity += Vector2(0, -jump_force * 100 * (delta if can_always_jump else 1))
    player.velocity += Vector2(jump_forward_force * 100 * delta * (1/4 if can_always_jump else 1), 0)
    var mouse_contribution = Vector2(last_mouse_movement.x * jump_mouse_side_mult, last_mouse_movement.y)
    print(mouse_contribution * jump_mouse_mult)
    player.velocity += mouse_contribution * jump_mouse_mult
    did_jump = true
    frames_touching_ground = 0
  
  if not Input.is_action_pressed("jump"):
    did_jump = false
  
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
    
    
