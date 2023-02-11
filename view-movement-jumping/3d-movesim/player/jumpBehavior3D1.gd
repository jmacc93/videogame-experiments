extends Node


var did_jump = false

export var can_always_jump = false
export var autohop = false

export var max_extra_jump_count = 1
var extra_jump_count = 0
export var extra_jump_count_mag_factor = 1
export var extra_jump_air_mag = 1.1

export var jump_mouse_mult = 0.1
export var jump_mouse_side_mult = 3

export var jump_mouse_walk_mult = 0.1
export var jump_walk_mouse_side_mult = 3

onready var walk_behavior = $'..'
onready var player = $'..'.get_node('..')

var mouse_magnitude = Vector2(0, 0)
var mouse_was_moved = false

var last_mouse_movement : Vector2

export(float, 0, 100) var jump_force = 18.0
export(float, 0, 400) var jump_forward_force = 6.0

export var debug_draw_mouse_magnitude = false
export var debug_draw_mouse_jump_contribution = false

onready var debug_label = player.find_node("debugLabel")
onready var draw_point = player.find_node("debugDrawPoint")

func _input(event):
  if event is InputEventMouseMotion:
    last_mouse_movement = event.relative
    mouse_was_moved = true

func _process(delta):
  
  var walk_vec = walk_behavior.last_walk_vec
  
  mouse_magnitude = mouse_magnitude + (Vector2(last_mouse_movement.x, -last_mouse_movement.y) - mouse_magnitude) * 0.3
  var adj_mouse_magnitude = log((mouse_magnitude.length() + 1)) * mouse_magnitude.normalized() * 2.5
  if debug_draw_mouse_magnitude:
    DebugDraw.draw_line(draw_point.global_translation, draw_point.global_translation + adj_mouse_magnitude.x * player.global_x_dir + adj_mouse_magnitude.y * player.global_y_dir, Color(1, 0, 0))
  
  if not mouse_was_moved:
    last_mouse_movement = Vector2(0, 0)
  
  var autohop_condition = autohop and player.velocity.y < 0.1
  var count_condition = (extra_jump_count < max_extra_jump_count) and (not did_jump)
  if Input.is_action_pressed("jump3d") and ((player.touching_ground and (not did_jump or autohop_condition)) or count_condition or can_always_jump):
    print('jumped! ', player.touching_ground, ' ', count_condition, ' ', can_always_jump)
    var extra_jump_count_mag = pow(extra_jump_count_mag_factor, extra_jump_count) if (not can_always_jump) else 1
    if not player.touching_ground:
      extra_jump_count_mag *= extra_jump_air_mag
    if player.velocity.y < 0:
      player.velocity.y = 0
    player.velocity += player.global_y_dir * jump_force * (delta if can_always_jump else 1) * walk_behavior.jump_mod * extra_jump_count_mag
    player.velocity += walk_vec * jump_forward_force * delta * (1/4 if can_always_jump else 1) * walk_behavior.jump_mod * extra_jump_count_mag
    var mouse_contribution = adj_mouse_magnitude.x * player.global_x_dir * jump_mouse_side_mult + adj_mouse_magnitude.y * player.global_y_dir
    player.velocity += mouse_contribution * jump_mouse_mult * walk_behavior.jump_mod * extra_jump_count_mag
    if walk_vec.length() > 0.001:
      var z_walk_proj = Lib.vec_proj(player.forward_dir, walk_vec)
      var z_walk_rej  = Lib.vec_rej(player.forward_dir, walk_vec)
      var mouse_walk_contribution = adj_mouse_magnitude.x * z_walk_rej * jump_walk_mouse_side_mult + adj_mouse_magnitude.y * z_walk_proj
      if debug_draw_mouse_jump_contribution:
        debug_label.set_text(String(mouse_walk_contribution))
      player.velocity += mouse_walk_contribution * jump_mouse_walk_mult * walk_behavior.jump_mod * extra_jump_count_mag
    did_jump = true
    extra_jump_count += 1
  
  if player.touching_ground:
    extra_jump_count = 0
  
  if not Input.is_action_pressed("jump3d"):
    did_jump = false
  
  mouse_was_moved = false
