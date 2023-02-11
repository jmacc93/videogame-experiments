extends RayCast

export var color : Color = Color(1, 0, 1)

func _process(delta):
  if is_colliding():
    var normal = get_collision_normal()
    var point  = get_collision_point()
    DebugDraw.draw_line(point, point + normal, color)
