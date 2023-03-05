extends Node

onready var parent : RigidBody = get_parent()

func _input(event: InputEvent):
  if Input.is_action_pressed("stop_rotation"):
    parent.add_torque(-parent.angular_velocity * Lib.last_delta * 100)
