extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var last_to_mouse_vector := Vector2(0,0)
var last_position        := Vector2(0,0)
var click_num := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _draw():
	draw_line(Vector2(0, 0), to_local(last_position + last_to_mouse_vector), Color(255, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	last_position = position
	last_to_mouse_vector = get_global_mouse_position() - position
	update()
	
	global_translate(last_to_mouse_vector * delta)
	
	if Input.is_action_just_pressed("clicked"):
		var click_node = get_node('/root/cameraFollowsMouse/clickObjectTemplate').duplicate() as Node2D
		click_node.name = 'clickPosition' + String(click_num)
		click_node.visible = true
		click_num += 1
		click_node.engage_timer(1000)
		click_node.position = get_local_mouse_position() + position
		
		get_node('/root/cameraFollowsMouse').add_child(click_node)
