extends RayCast

onready var parent : RigidBody

export var draw_debug_lines = false

export var lift_power = 1.0
export var drag_upward_power = 10.0
export var drag_backward_power = 0.5

onready var last_global_translation = global_translation

onready var debug_point : Spatial = $debugPoint

export var square_velocity = false

func _ready():
  parent = Lib.get_parent_with_class(self, RigidBody)
  assert(parent, 'No RigidBody parent found')


func _physics_process(delta):
  
  var velocity = (global_translation - last_global_translation) / delta
  
  var lift_dir = Lib.to_global_vec(self, cast_to).normalized()
  
  var lift_force = lift_dir.cross(velocity).length() * velocity.length() * lift_dir * lift_power * 0.001
  
  var drag_upward_force
  var drag_backward_force
  if square_velocity:
    drag_upward_force   = -Lib.vec_proj(velocity, lift_dir) * velocity.length() * drag_upward_power * 0.01
    drag_backward_force = -Lib.vec_rej(velocity, lift_dir) * velocity.length() * drag_backward_power * 0.001
  else:
    drag_upward_force   = -Lib.vec_proj(velocity, lift_dir) * drag_upward_power * 0.01
    drag_backward_force = -Lib.vec_rej(velocity, lift_dir) * drag_backward_power * 0.001
  var drag_force = drag_upward_force + drag_backward_force
  
  if draw_debug_lines and debug_point:
    DebugDraw.draw_line(debug_point.global_translation, debug_point.global_translation + velocity, Color(0.0, 1.0, 0.0))
    DebugDraw.draw_line(debug_point.global_translation, debug_point.global_translation + lift_dir, Color(1.0, 1.0, 0.0))
    DebugDraw.draw_line(debug_point.global_translation, debug_point.global_translation + lift_force, Color(0.0, 0.0, 1.0))
    DebugDraw.draw_line(debug_point.global_translation, debug_point.global_translation + drag_force, Color(1.0, 0.0, 0.0))
  
  parent.add_force(lift_force, global_translation - parent.global_translation)
  parent.add_force(drag_force, global_translation - parent.global_translation)
  
  last_global_translation = global_translation

