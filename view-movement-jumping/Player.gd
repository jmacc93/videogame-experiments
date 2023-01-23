extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var move_rate := 100.0
export var jump_force := 1000.0

var velocity := Vector2(0.0, 0.0)
var touching_ground := false
var traveling_left  := false
var traveling_right := false
var traveling       := false
var walking         := false
var last_walk_time  := 0.0
var walk_stop_delay := 10.0

var right_arm_area: Area2D
var left_arm_area:  Area2D
var right_leg_area: Area2D
var left_leg_area:  Area2D
var feet_area:      Area2D

export var walk_mult_max := 5
export var walk_mult_unit_speed := 20

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
	
	var speed = velocity.length()
	if speed > scene.max_speed:
		velocity = velocity.normalized() * scene.max_speed
	
	traveling_right = (velocity.x > 0)
	traveling_left  = (velocity.x < 0)
	traveling = traveling_left or traveling_right
	
	walking = (OS.get_ticks_msec() < last_walk_time + walk_stop_delay)
	
	velocity = velocity + Vector2(0, 9.8 * scene.gravity_rate) * delta
	var new_velocity = self.move_and_slide(velocity, Vector2(0, -1))
	touching_ground = (feet_area.get_overlapping_bodies().size() > 0)
	velocity = new_velocity
	
	if touching_ground and traveling and (not walking):
		velocity.x -= sign(velocity.x) * 10.0
		if abs(velocity.x) < scene.min_friction_speed:
			velocity.x = 0
	
	var walk_multiplier = max(walk_mult_max /(velocity.x/(walk_mult_unit_speed/(-1 + walk_mult_max)) + 1), 1)
	
	if Input.is_action_pressed("move_left"):
		if right_leg_area.get_overlapping_bodies().size() > 0:
			velocity += Vector2(-move_rate*walk_multiplier, 0)
			last_walk_time = OS.get_ticks_msec()
		elif feet_area.get_overlapping_bodies().size() > 0:
			velocity += Vector2(-move_rate*walk_multiplier/2, 0)
			last_walk_time = OS.get_ticks_msec()
	elif Input.is_action_pressed("move_right"):
		if left_leg_area.get_overlapping_bodies().size() > 0:
			velocity += Vector2(move_rate*walk_multiplier, 0)
			last_walk_time = OS.get_ticks_msec()
		elif feet_area.get_overlapping_bodies().size() > 0:
			velocity += Vector2(move_rate*walk_multiplier/2, 0)
			last_walk_time = OS.get_ticks_msec()
	
	if Input.is_action_pressed("jump") and touching_ground:
		velocity += Vector2(0, -jump_force)
		last_walk_time = OS.get_ticks_msec()
	
	
