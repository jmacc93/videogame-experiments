extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity := Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_A:
			velocity += Vector2(-10, 0)
		elif event.scancode == KEY_D:
			velocity += Vector2(10, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var scene = get_node('/root/2d-scene')
	print_debug(scene)
	print_debug(scene.gravity_rate)
	velocity = velocity + Vector2(0, 9.8 * scene.gravity_rate) * delta
	var new_velocity = self.move_and_slide(velocity)
	velocity = new_velocity
	
