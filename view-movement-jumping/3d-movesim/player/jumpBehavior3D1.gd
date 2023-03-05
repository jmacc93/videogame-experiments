extends Node


#did we already use this key press for a jump?
var already_jumped_on_key_press = false

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
export(float, 0, 100) var wall_jump_force = 5
export(float, 0, 2) var wall_jump_upward_mod = 0.5
export(float, 0, 15) var wall_jump_mouse_mod = 5

export var debug_draw_mouse_magnitude = false
export var debug_draw_mouse_jump_contribution = false

onready var debug_label = player.find_node("debugLabel")
onready var draw_point = player.find_node("debugDrawPoint")

export var cancel_vertical_vel_on_jump = true

export var reset_extra_jumps_on_wall_walk = false

var last_wall_jump_time = 0
export var wall_jump_cooldown = 0.5

func _input(event):
  if event is InputEventMouseMotion:
    last_mouse_movement = event.relative
    mouse_was_moved = true

func _process(delta):
  
  var walk_vec = walk_behavior.last_walk_vec
  
  mouse_magnitude = mouse_magnitude + (Vector2(last_mouse_movement.x, -last_mouse_movement.y) - mouse_magnitude) * 0.3
  var adj_mouse_magnitude = log((mouse_magnitude.length() + 1)) * mouse_magnitude.normalized() * 2.5
  if not mouse_was_moved:
    last_mouse_movement = Vector2(0, 0)
  
  if debug_draw_mouse_magnitude:
    DebugDraw.draw_line(draw_point.global_translation, draw_point.global_translation + adj_mouse_magnitude.x * player.global_x_dir + adj_mouse_magnitude.y * player.global_y_dir, Color(1, 0, 0))
  
  #actually perform the jump if possible
  var wall_jumping = (not player.touching_ground) and (walk_behavior.left_wall_walking or walk_behavior.right_wall_walking)
  var wall_jump_condition = wall_jumping and (last_wall_jump_time + wall_jump_cooldown * 1000 < OS.get_ticks_msec())
  var autohop_condition = autohop and player.velocity.y < 0.1
  var extra_jump_count_condition = (extra_jump_count < max_extra_jump_count) and (not already_jumped_on_key_press)
  var ground_condition = player.touching_ground and (not already_jumped_on_key_press or autohop_condition)
  var can_jump_this_frame = ground_condition or wall_jump_condition or extra_jump_count_condition or can_always_jump
  if Input.is_action_pressed("jump3d") and can_jump_this_frame:
    
    #calculate multiple jump power modification
    var extra_jump_count_mag = pow(extra_jump_count_mag_factor, extra_jump_count) if (not can_always_jump) else 1
    if not player.touching_ground:
      extra_jump_count_mag *= extra_jump_air_mag
    var combined_jump_mod = walk_behavior.jump_mod * extra_jump_count_mag
    
    #start the jump at zero vertical velocity?
    if cancel_vertical_vel_on_jump and (player.velocity.y < 0):
      player.velocity.y = 0
    
    if wall_jumping:
      last_wall_jump_time = OS.get_ticks_msec()
    
    #direct the jump if on a wall
    var wall_jump_vector
    if not walk_behavior.wall_walking:
      wall_jump_vector = Vector3(0, 0, 0)
    elif (walk_behavior.left_wall_walking) and (walk_behavior.right_wall_walking):
      wall_jump_vector = player.global_y_dir * wall_jump_force
    elif walk_behavior.left_wall_walking:
      wall_jump_vector = walk_behavior.left_collision_normal * wall_jump_force
    elif walk_behavior.right_wall_walking:
      wall_jump_vector = walk_behavior.right_collision_normal * wall_jump_force
    
    #add upward velocity shifted by wall jump offset while preserving original jump energy
    var final_jump_force = jump_force * combined_jump_mod
    var primary_jump_vector = player.global_y_dir * final_jump_force
    primary_jump_vector.y *= (wall_jump_upward_mod if wall_jumping else 1)
    primary_jump_vector += wall_jump_vector
    player.velocity +=  primary_jump_vector * (delta if can_always_jump else 1)
    
    #jump along walking direction
    var final_forward_jump_force = jump_forward_force * combined_jump_mod
    var walk_jump_vector = walk_vec * final_forward_jump_force
    player.velocity += walk_jump_vector * delta * (1/4 if can_always_jump else 1) 
    
    #jump in mouse direction
    var mouse_contribution = adj_mouse_magnitude.x * player.global_x_dir * jump_mouse_side_mult + adj_mouse_magnitude.y * player.global_y_dir
    var final_mouse_force = jump_mouse_mult * combined_jump_mod * (wall_jump_mouse_mod if wall_jumping else 1)
    player.velocity += mouse_contribution * final_mouse_force
    
    #jump in in mouse direction modulated by walking direction
    if walk_vec.length() > 0.001:
      var z_walk_proj = Lib.vec_proj(player.forward_dir, walk_vec)
      var z_walk_rej  = Lib.vec_rej(player.forward_dir, walk_vec)
      var mouse_walk_contribution = adj_mouse_magnitude.x * z_walk_rej * jump_walk_mouse_side_mult + adj_mouse_magnitude.y * z_walk_proj
      if debug_draw_mouse_jump_contribution:
        debug_label.set_text(String(mouse_walk_contribution))
      player.velocity += mouse_walk_contribution * jump_mouse_walk_mult * combined_jump_mod
    
    already_jumped_on_key_press = true
    extra_jump_count += 1
  
  #
  
  #reset extra jumps
  if player.touching_ground or (reset_extra_jumps_on_wall_walk and walk_behavior.wall_walking):
    extra_jump_count = 0
  
  if not Input.is_action_pressed("jump3d"):
    already_jumped_on_key_press = false
  
  mouse_was_moved = false
