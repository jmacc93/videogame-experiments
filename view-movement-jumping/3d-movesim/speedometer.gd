extends Label3D

var last_position : Vector3

func _process(delta):
  var current_position : Vector3 = $'..'.global_translation
  var position_difference = current_position - last_position
  var speed = sqrt(position_difference.x * position_difference.x + position_difference.z * position_difference.z) / delta
  set_text(String(floor(speed * 10) / 10))
  last_position = current_position
