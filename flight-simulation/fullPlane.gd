extends RigidBody
class_name Airplane

var target_dir = Vector3(0, 0, 1)
var target_normal = Vector3(0, 1, 0)

export var show_target_dir = false

func _process(delta):
  if show_target_dir:
    DebugDraw.draw_line(global_translation, global_translation + target_dir * 10, Color(0.0, 1.0, 1.0))
