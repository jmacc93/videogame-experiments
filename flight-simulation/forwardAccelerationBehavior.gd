extends Node

onready var parent : RigidBody = get_parent()

export var power = 1.0

func _process(delta):
  if Input.is_action_pressed("fly_forward"):
    var z_dir = Lib.to_global_vec(parent, Vector3(0, 0, 1))
    parent.add_central_force(- z_dir * power * 10)
