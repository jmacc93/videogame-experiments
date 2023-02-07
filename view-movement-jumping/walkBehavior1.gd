extends Node

onready var player = $'..'

var walking = false

var last_walking_dir : Vector3

export var can_always_walk = false
export var can_always_jump = false
export var autohop = false

export(float, 0, 100) var jump_force = 18
export(float, 0, 400) var jump_forward_force = 6

export(float, 0, 200) var move_rate = 26
export(float, 0, 3) var forward_walk_mult  = 1.0
export(float, 0, 3) var side_walk_mult     = 1.0
export(float, 0, 3) var backward_walk_mult = 1.0

var air_control_speed = 10
var air_control_walk_mag = 30

export var fric_mult = 15
export var auto_friction = 0.1

export var jump_mouse_mult = 0.1
export var jump_mouse_side_mult = 3

export var jump_mouse_walk_mult = 0.1
export var jump_walk_mouse_side_mult = 3

var lib = preload('res://lib.gd')

var last_mouse_movement : Vector2

var frames_touching_ground = 0
export var friction_begin_frames = 3

func lint(a, b, u):
  return a + (b - a) * u

func average_casts(raycasts_array):
  var colliding_num = 0
  var colliding_sum = Vector3(0, 0, 0)
  var normal_sum = Vector3(0, 0, 0)
  for cast in raycasts_array:
    if cast.is_colliding():
      var cast_vec = lib.to_global_vec3(cast, Vector3(0, 1, 0))
      colliding_num += 1
      colliding_sum += cast_vec
      normal_sum = cast.get_collision_normal()
  if colliding_num == 0:
    return [colliding_sum, colliding_sum]
  else:
    return [colliding_sum / colliding_num, normal_sum / colliding_num]

func friction_mag_mod(friction_vector: Vector3):
  var friction_mag = friction_vector.length()
  var new_mag = pow(friction_mag, 2) + 1
  return new_mag * (friction_vector / friction_mag)

var did_jump = false

func _input(event):
    if event is InputEventMouseMotion:
        last_mouse_movement = event.relative

func _process(delta):
  var draw_scale = 0.1
  var debug_label = player.get_node("debugLabel")
  var draw_point = player.get_node("debugDrawPoint").global_translation
  
  var walk_vec = Vector3(0, 0, 0)
  
  if Input.is_action_pressed("move_forward"):
    walk_vec +=  player.global_z_dir * move_rate * forward_walk_mult
  
  if Input.is_action_pressed("move_backward"):
    walk_vec += -player.global_z_dir * move_rate * backward_walk_mult
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -player.global_x_dir * move_rate * side_walk_mult
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  player.global_x_dir * move_rate * side_walk_mult
  
  var autohop_condition = autohop and player.velocity.y < 0.1
  if Input.is_action_pressed("jump3d") and ((player.touching_ground and (not did_jump or autohop_condition)) or can_always_jump):
    player.velocity += player.global_y_dir * jump_force * (delta if can_always_jump else 1)
    player.velocity += walk_vec * jump_forward_force * delta * (1/4 if can_always_jump else 1)
    var mouse_contribution = last_mouse_movement.x * player.global_x_dir * jump_mouse_side_mult - last_mouse_movement.y * player.global_y_dir
    player.velocity += mouse_contribution * jump_mouse_mult
    if walk_vec.length() > 0.001:
      var z_walk_proj = lib.vec_proj(player.global_z_dir, walk_vec)
      var z_walk_rej  = lib.vec_rej(player.global_z_dir, walk_vec)
      var mouse_walk_contribution = last_mouse_movement.x * z_walk_rej * jump_walk_mouse_side_mult - last_mouse_movement.y * z_walk_proj
      debug_label.set_text(String(mouse_walk_contribution))
      player.velocity += mouse_walk_contribution * jump_mouse_walk_mult
    did_jump = true
  var z_walk_proj = lib.vec_proj(player.global_z_dir, walk_vec)
  var z_walk_rej  = lib.vec_rej(player.global_z_dir, walk_vec)
  var mouse_walk_contribution = last_mouse_movement.x * z_walk_rej * jump_walk_mouse_side_mult - last_mouse_movement.y * z_walk_proj
  DebugDraw.draw_line(draw_point, draw_point + mouse_walk_contribution * draw_scale, Color(1, 1, 0))
  
  if not Input.is_action_pressed("jump3d"):
    did_jump = false
  
  walking = walk_vec.length() > 0.001

  last_walking_dir = walk_vec.normalized()
  DebugDraw.draw_line(draw_point, draw_point + walk_vec * draw_scale, Color(1, 0, 0))
  DebugDraw.draw_line(draw_point, draw_point + player.hor_velocity * draw_scale, Color(0, 0, 1))
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
    DebugDraw.draw_line(draw_point, draw_point + air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * draw_scale, Color(0, 1, 0))
    player.velocity += air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * delta
    player.hor_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
    if (player.hor_velocity - walk_vec).length() < 10:
      player.velocity += walk_vec - player.hor_velocity
  else:
    var walk_along_vel = walk_vec.dot(player.hor_velocity)
    var walk_rej  = lib.vec_rej(walk_vec, player.hor_velocity)
    var walk_proj = lib.vec_proj(walk_vec, player.hor_velocity)
    if walk_along_vel < 0:
      DebugDraw.draw_line(draw_point, draw_point + air_control_walk_mag * (walk_vec - player.hor_velocity).normalized() * draw_scale, Color(0, 1, 0))
      player.velocity += air_control_walk_mag * (walk_rej + walk_proj) * delta
    else:
      DebugDraw.draw_line(draw_point, draw_point + walk_rej * draw_scale, Color(0, 1, 0))
      player.velocity += air_control_walk_mag * walk_rej * delta
    
    
