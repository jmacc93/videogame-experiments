extends RayCast

export var show_debug_lines = false

onready var rigid_body = Lib.get_parent_with_class(self, RigidBody)

export var action : String

export var power = 1.0

func _physics_process(delta):
  if rigid_body and Input.is_action_pressed(action):
    var force = Lib.to_global_vec(self, cast_to).normalized() * power * 100
    rigid_body.add_force(force, self.global_translation - rigid_body.global_translation)
    if show_debug_lines:
      DebugDraw.draw_line(self.global_translation, self.global_translation - force)
