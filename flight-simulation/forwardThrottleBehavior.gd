extends RayCast

export var throttle_increment_rate = 0.05
export var max_throttle_power = 3.0
var current_throttle = 0.0 #on [0, 1]

onready var parent_rigid_body : RigidBody = Lib.get_parent_with_class(self, RigidBody)
onready var throttleDisplay : ColorRect = get_node_or_null('throttleDisplay')
export var max_throttle_display_width = 150

func _physics_process(delta):
  if Input.is_action_pressed("throttle_forward"):
    current_throttle += throttle_increment_rate * delta
    if current_throttle > 1.0:
      current_throttle = 1.0
  elif Input.is_action_pressed("throttle_back"):
    current_throttle -= throttle_increment_rate * delta
    if current_throttle < 0.0:
      current_throttle = 0.0
  
  if throttleDisplay:
    throttleDisplay.rect_size.x = max_throttle_display_width * current_throttle
  
  if parent_rigid_body:
    var force_dir = Lib.to_global_vec(self, cast_to)
    parent_rigid_body.add_force(-max_throttle_power * force_dir, global_translation - parent_rigid_body.global_translation)
