extends Node

func _input(event: InputEvent):
  if Input.is_action_just_pressed('debug_punt_upward'):
    var parent = Lib.get_parent_with_class(self, RigidBody) as RigidBody
    if parent:
      parent.apply_central_impulse(Vector3(0, 10, 0))
