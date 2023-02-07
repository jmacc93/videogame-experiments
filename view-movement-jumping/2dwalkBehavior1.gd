extends Node

onready var player = $'..'

var walking = false

var last_walking_dir : Vector2

export var can_always_walk = false
export var can_always_jump = false
export var autohop = false

export(float, 0, 100) var jump_force = 18
export(float, 0, 400) var jump_forward_force = 6

export(float, 0, 200) var move_rate = 26
export(float, 0, 3) var walk_mult  = 1.0
export(float, 0, 3) var backward_walk_mult = 1.0

var air_control_speed = 10
var air_control_walk_mag = 30

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

func _process(delta):
  var draw_scale = 0.1
#  var debug_label = player.get_node("debugLabel")
#  var draw_point = player.get_node("debugDrawPoint").global_translation
  
  var walk_vec = Vector2(0, 0)
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -x_dir * move_rate * walk_mult
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  x_dir * move_rate * walk_mult
  
  var autohop_condition = autohop and player.velocity.y < 0.1
  if Input.is_action_pressed("jump") and ((player.touching_ground and (not did_jump or autohop_condition)) or can_always_jump):
    player.velocity += -y_dir * jump_force * (delta if can_always_jump else 1)
    player.velocity += walk_vec * jump_forward_force * delta * (1/4 if can_always_jump else 1)
    var mouse_contribution = last_mouse_movement.x * x_dir * jump_mouse_side_mult - last_mouse_movement.y * y_dir
    player.velocity += mouse_contribution * jump_mouse_mult
    did_jump = true
#  DebugDraw.draw_line(draw_point, draw_point + mouse_walk_contribution * draw_scale, Color(1, 1, 0))
  
  if not Input.is_action_pressed("jump"):
    did_jump = false
  
  walking = walk_vec.length() > 0.001

  last_walking_dir = walk_vec.normalized()
#  DebugDraw.draw_line(draw_point, draw_point + walk_vec * draw_scale, Color(1, 0, 0))
#  DebugDraw.draw_line(draw_point, draw_point + player.hor_velocity * draw_scale, Color(0, 0, 1))
  if player.touching_ground:
    if frames_touching_ground > friction_begin_frames:
      var fric_power = auto_friction
      player.velocity += fric_power * (walk_vec - player.hor_velocity) * delta
      player.hor_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
    else:
      frames_touching_ground += 1
  else:
    frames_touching_ground = 0
  if player.hor_velocity.length() < air_control_speed:
#    DebugDraw.draw_line(draw_point, draw_point + air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * draw_scale, Color(0, 1, 0))
    player.velocity += air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * delta
    player.hor_velocity = Vector2(player.velocity.x, 0.0)
    if (player.hor_velocity - walk_vec).length() < 10:
      player.velocity += walk_vec - player.hor_velocity
  else:
    var walk_along_vel = walk_vec.dot(player.hor_velocity)
    var walk_rej  = lib.vec_rej(walk_vec, player.hor_velocity)
    var walk_proj = lib.vec_proj(walk_vec, player.hor_velocity)
    if walk_along_vel < 0:
#      DebugDraw.draw_line(draw_point, draw_point + air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * draw_scale, Color(0, 1, 0))
      player.velocity += air_control_walk_mag * (walk_rej + walk_proj) * delta
    else:
#      DebugDraw.draw_line(draw_point, draw_point + walk_rej * draw_scale, Color(0, 1, 0))
      player.velocity += air_control_walk_mag * walk_rej * delta
    
    
