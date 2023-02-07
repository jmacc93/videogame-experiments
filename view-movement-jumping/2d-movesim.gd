extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var gravity_rate := 50.0
export var min_friction_speed := 20.0

export var after_jump_gravity_mult : Curve
export var after_jump_gravity_time_max : float = 3

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
