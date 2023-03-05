extends Node

onready var player : KinematicBody2D = find_parent('Player')
onready var walk_behavior : Node = get_parent()

export var can_always_jump = false
export var autohop = false

export(float, 0, 100) var jump_force = 2.7
export(float, 0, 400) var jump_forward_force = 1.5

export var jump_mouse_mult = 30.0
export var jump_mouse_side_mult = 0.2

var last_mouse_movement : Vector2

var did_jump = false

export var turnaround_frames = 6
export var turnaround_jump_forward_mult = 2.0
export var last_frame_hor_dir = 1
export var current_turnaround_frame = 0

var mouse_was_moved = false
var mouse_magnitude = Vector2(0, 0)
export var mouse_mag_decay_rate = 0.2

func _input(event):
    if event is InputEventMouseMotion:
      last_mouse_movement = event.relative
      mouse_was_moved = true

onready var debug_point = $"../../debugPoint/Sprite"
onready var debug_text = player.find_node('debugText')

func _process(delta):
  
  mouse_magnitude = mouse_magnitude + (Vector2(last_mouse_movement.x, last_mouse_movement.y) - mouse_magnitude) * mouse_mag_decay_rate
  var adj_mouse_magnitude = log((mouse_magnitude.length() + 1)) * mouse_magnitude.normalized() * 2.5
  if not mouse_was_moved:
    last_mouse_movement = Vector2(0, 0)
  
  debug_point.position = adj_mouse_magnitude * 2
  debug_text.text = String(Vector2(floor(adj_mouse_magnitude.x*10)/10,floor(adj_mouse_magnitude.y*10)/10))
  
  if sign(player.hor_velocity) != last_frame_hor_dir:
    current_turnaround_frame = 0
  else:
    current_turnaround_frame += 1
  
  var autohop_condition = autohop and player.velocity.y < 0.1
  if Input.is_action_pressed("jump") and ((player.touching_ground and (not did_jump or autohop_condition)) or can_always_jump):
    var turnaround_mult = turnaround_jump_forward_mult if (current_turnaround_frame < turnaround_frames) else 1.0
    if (current_turnaround_frame < turnaround_frames):
      print("turnaround multiplied ", current_turnaround_frame, ' ',  turnaround_frames, ' ', turnaround_mult)
    player.velocity += Vector2(0, -jump_force * turnaround_mult * 100 * (delta if can_always_jump else 1))
    player.velocity += Vector2(jump_forward_force * sign(walk_behavior.walk_vec) * turnaround_mult * 100 * (delta if can_always_jump else 1) * (1/4 if can_always_jump else 1), 0)
    var mouse_contribution = Vector2(adj_mouse_magnitude.x * jump_mouse_side_mult, adj_mouse_magnitude.y)
    player.velocity += mouse_contribution * jump_mouse_mult
    did_jump = true
    walk_behavior.frames_touching_ground = 0
    print('jump! mouse contrib mag: ', mouse_contribution.length())
  
  if not Input.is_action_pressed("jump"):
    did_jump = false
  
  last_frame_hor_dir = sign(player.hor_velocity)
  
  mouse_was_moved = false
    
