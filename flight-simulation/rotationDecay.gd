extends Node

onready var rigid_body : RigidBody = Lib.get_parent_with_class(self, RigidBody)

export var rate = 1.0

func _physics_process(delta):
  if rigid_body and rigid_body.angular_velocity.length() > 0.1:
    rigid_body.add_torque(-rigid_body.angular_velocity * rate)
