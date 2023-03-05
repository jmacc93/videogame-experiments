extends RayCast

onready var parent : RigidBody

export var power = 1.0
export var action : String = ''

onready var debug_point : Spatial = $debugPoint

func _ready():
  parent = Lib.get_parent_with_class(self, RigidBody)
  assert(parent, 'No parent RigidBody found')

func _process(delta):
  
  if Input.is_action_pressed(action):
    var force_dir = Lib.to_global_vec(self, cast_to)
    parent.add_force(force_dir * power * delta, global_translation - parent.global_translation)
    
    if debug_point:
      DebugDraw.draw_line(debug_point.global_translation, debug_point.global_translation + force_dir * power, Color(1.0, 1.0, 0.0))
