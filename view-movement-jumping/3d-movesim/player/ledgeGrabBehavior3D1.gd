extends Spatial

onready var upper_cast : RayCast = $upperCast
onready var lower_cast : RayCast = $lowerCast
onready var player : KinematicBody = $'..'

export var grab_threshold = 1.0

var grabbing = false
export var pull_up_force = 10.0

func get_grab_force():
  if not lower_cast.is_colliding():
    return 0
  
  DebugDraw.draw_points([lower_cast.get_collision_point(), upper_cast.get_collision_point()], 0.5)
  var lower_len = (lower_cast.get_collision_point() - lower_cast.global_translation).length()
  var upper_len = (upper_cast.get_collision_point() - upper_cast.global_translation).length()
  return max(upper_len - lower_len, 0)

func _process(delta):
  if lower_cast.is_colliding() and Input.is_action_pressed("move_forward"):
    var grab_force = max(exp(get_grab_force()) - 1, 1)
    print('moving up ', get_grab_force(), ' ', pull_up_force * grab_force)
    player.velocity += pull_up_force * player.global_y_dir * grab_force * delta
