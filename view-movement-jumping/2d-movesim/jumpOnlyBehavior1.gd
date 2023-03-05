extends Node

onready var player : KinematicBody2D = get_parent()

export var move_jump_sideward_power = 1.0
export var move_jump_up_power = 1.0

export var jump_up_mult = 4.0

export var move_jump_mult = 1.0

func _process(delta):
  
  var move_dir = 0
  var do_jump = false
  
  if Input.is_action_pressed("move_left"):
    move_dir = -1
  elif Input.is_action_pressed("move_right"):
    move_dir = 1
  
  do_jump = Input.is_action_pressed("jump")
  
  var moving = (move_dir != 0)
  
  var jump_vec = Vector2(0, 0)
  
  if player.touching_ground and (player.velocity.y >= 0) and moving:
    jump_vec += Vector2(move_jump_sideward_power * move_dir * 60, -move_jump_up_power * 40 * (jump_up_mult if do_jump else 1.0)) * move_jump_mult
  
  player.velocity += jump_vec
