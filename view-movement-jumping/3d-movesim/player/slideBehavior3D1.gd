extends Node

onready var walk_behavior = $'..'
onready var player = $'../..'

var sliding = false

export(float, 0, 1) var friction_mod = 0.01
export(float, 0, 1) var walk_mod = 0.2
export(float, 0, 3) var jump_mod = 1.5
export(float, 0, 3) var sliding_jump_mod = 0.5

var last_standup_time = 0
var jump_mod_stand_reset_delay = 0.25

var sliding_in_previous_frame = false
var jump_mod_active = false

func _process(delta):
  sliding = Input.is_action_pressed('drop') and player.touching_ground
  
  if sliding:
    walk_behavior.friction_mod = friction_mod
    walk_behavior.walk_mod = walk_mod
    walk_behavior.jump_mod = sliding_jump_mod
    sliding_in_previous_frame = true
  else:
    walk_behavior.friction_mod = 1
    walk_behavior.walk_mod = 1
    var current_time = OS.get_ticks_msec()
    if sliding_in_previous_frame:
      last_standup_time = current_time
      walk_behavior.jump_mod = jump_mod
      jump_mod_active = true
    elif last_standup_time + jump_mod_stand_reset_delay * 1000 < current_time:
      walk_behavior.jump_mod = 1
      jump_mod_active = false
    sliding_in_previous_frame = false
