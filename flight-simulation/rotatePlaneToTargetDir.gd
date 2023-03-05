extends Node

onready var parent_plane : Airplane = Lib.get_parent_with_class(self, Airplane)

export var rotation_rate = 1.0

export var local_alignment_dir = Vector3(0, 0, 1)

export var max_angle = 45

var slowing_exponent = 1

export var on_mouse_left = true

func _physics_process(delta):
  if parent_plane and ((not on_mouse_left) or Input.is_action_pressed("mouse_left")):
    var alignment_dir = Lib.to_global_vec(parent_plane, local_alignment_dir)
    var target_dir = parent_plane.target_dir
    
    #rotate to target direction if not close to it
    var not_close_to_target_alignment = (alignment_dir.angle_to(target_dir) > PI/128)
    if not_close_to_target_alignment:
      var rotation_vec = alignment_dir.cross(target_dir).normalized()
      var slowing_torque = -parent_plane.angular_velocity
      DebugDraw.draw_line(parent_plane.global_translation, parent_plane.global_translation + slowing_torque * 100)
      
      var rotation_power = pow(alignment_dir.dot(target_dir) - 1, 2) / 4 + 1
#      var slowing_torque_power = 1 - pow(abs(alignment_dir.dot(target_dir) - 1), slowing_exponent) / pow(2, slowing_exponent)
      var slowing_torque_power = exp(-slowing_torque.length())
      
#      parent_plane.add_torque(delta * (rotation_vec * rotation_power * rotation_rate * 1000.0 + slowing_torque * slowing_torque_power * rotation_rate * 1000))
#      parent_plane.add_torque(delta * (rotation_vec * rotation_power * rotation_rate * 1000.0))
      parent_plane.add_torque(delta * (rotation_vec * rotation_power * rotation_rate * slowing_torque_power * 1000.0 + slowing_torque * 100))
    
