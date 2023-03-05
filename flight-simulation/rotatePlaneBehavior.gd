extends Node

onready var parent : RigidBody = Lib.get_parent_with_class(self, RigidBody)

export var slide_left_right_power = 1.0
export var left_right_power = 1.0
export var up_down_power = 1.0

func _physics_process(delta):
  
  var x_dir = Lib.to_global_vec(parent, Vector3(1, 0, 0))
  var y_dir = Lib.to_global_vec(parent, Vector3(0, 1, 0))
  var z_dir = Lib.to_global_vec(parent, Vector3(0, 0, 1))
  
  if Input.is_action_pressed("rotate_left"):
    parent.add_torque(-z_dir * left_right_power * 50)
  if Input.is_action_pressed("rotate_right"):
    parent.add_torque(z_dir * left_right_power * 50)
  if Input.is_action_pressed("rotate_forward"):
    parent.add_torque(x_dir * left_right_power * 50)
  if Input.is_action_pressed("rotate_backward"):
    parent.add_torque(-x_dir * left_right_power * 50)
  if Input.is_action_pressed("rotate_slide_left"):
    print("slide left")
    parent.add_torque(y_dir * slide_left_right_power * 50)
  if Input.is_action_pressed("rotate_slide_right"):
    parent.add_torque(-y_dir * slide_left_right_power * 50)
