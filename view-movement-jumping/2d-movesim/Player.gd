extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var move_rate := 100.0
export var jump_force := 400.0

export var can_always_walk : bool = false

var velocity := Vector2(0.0, 0.0)
var touching_ground := false
var traveling_left  := false
var traveling_right := false
var traveling       := false
var walking         := false
var last_walk_time  := 0.0
var walk_stop_delay := 10.0
var last_touching_ground_time  := 0.0
export(float, 0, 1000) var max_walk_speed = 100

var right_arm_area: Area2D
var left_arm_area:  Area2D
var right_leg_area: Area2D
var left_leg_area:  Area2D
var feet_area:      Area2D

export var walk_mult_profile : Curve
export var aniso_walk_mult_profile: Curve
export var friction_curve: Curve


# Called when the node enters the scene tree for the first time.
func _ready():
  right_arm_area  = get_node("./RightArmArea")
  right_leg_area  = get_node("./RightLegArea")
  left_arm_area   = get_node("./LeftArmArea")
  left_leg_area   = get_node("./LeftLegArea")
  feet_area       = get_node("./FeetArea")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  var scene = get_node('/root/2d-movesim')
  
  traveling_right = (velocity.x > 0)
  traveling_left  = (velocity.x < 0)
  traveling = traveling_left or traveling_right
  
  walking = (OS.get_ticks_msec() < last_walk_time + walk_stop_delay)
  
  var in_air_time = (OS.get_ticks_msec() - last_touching_ground_time) / 1000
  var gravity_mult = scene.after_jump_gravity_mult.interpolate(in_air_time / scene.after_jump_gravity_time_max)
  if not touching_ground:
    print("in air ", in_air_time, " mult ", gravity_mult)
  
  velocity = velocity + Vector2(0, 9.8 * scene.gravity_rate * gravity_mult) * delta
  var new_velocity = self.move_and_slide(velocity, Vector2(0, -1))
  var previously_touching_ground = touching_ground
  touching_ground = (feet_area.get_overlapping_bodies().size() > 0)
  if not touching_ground and previously_touching_ground:
    last_touching_ground_time = OS.get_ticks_msec()
  velocity = new_velocity
  

  var speed = velocity.length()
#	if speed > scene.max_speed:
#		velocity = velocity.normalized() * scene.max_speed
  
  if touching_ground and traveling and (not walking):
    velocity.x -= sign(velocity.x) * friction_curve.interpolate(abs(velocity.x) / max_walk_speed) * 10.0
    if abs(velocity.x) < scene.min_friction_speed:
      velocity.x = 0
  
  var walk_multiplier = walk_mult_profile.interpolate(speed / max_walk_speed)
  
  
  if Input.is_action_pressed("move_left"):
    var aniso_walk_mult = aniso_walk_mult_profile.interpolate(velocity.x + 1)
    if right_leg_area.get_overlapping_bodies().size() > 0 or can_always_walk:
      velocity += Vector2(-move_rate*walk_multiplier*aniso_walk_mult, 0)
    elif feet_area.get_overlapping_bodies().size() > 0 :
      velocity += Vector2(-move_rate*walk_multiplier*aniso_walk_mult/2, 0)
  elif Input.is_action_pressed("move_right"):
    var aniso_walk_mult = aniso_walk_mult_profile.interpolate(-velocity.x + 1)
    if left_leg_area.get_overlapping_bodies().size() > 0 or can_always_walk:
      velocity += Vector2(move_rate*walk_multiplier*aniso_walk_mult, 0)
    elif feet_area.get_overlapping_bodies().size() > 0:
      velocity += Vector2(move_rate*walk_multiplier*aniso_walk_mult/2, 0)
  
  if Input.is_action_just_pressed("jump") and touching_ground:
    velocity += velocity.normalized() * jump_force / 10.0
    velocity += Vector2(0, -jump_force)
  
  
