extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var end_time = 0

func engage_timer(delay):
	end_time = OS.get_ticks_msec() + delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if end_time > 0 and end_time < OS.get_ticks_msec():
		 self.queue_free()
