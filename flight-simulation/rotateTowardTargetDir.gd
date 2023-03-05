extends Node

export var use_negative_target = false

onready var parent_plane : Airplane = Lib.get_parent_with_class(self, Airplane)
onready var parent_spatial : Spatial = Lib.get_parent_with_class(self, Spatial)

export var rotation_rate = 1.0

export var local_alignment_dir = Vector3(0, 0, 1)
onready var original_local_alignment_dir = Lib.local_to_local_vec(parent_spatial, parent_spatial.get_parent(), local_alignment_dir)
onready var initial_rotation_quat = Quat(parent_spatial.rotation)

export var max_angle = 45

func _physics_process(delta):
  if parent_plane:
    var alignment_dir = Lib.to_global_vec(parent_spatial, local_alignment_dir)
    var target_dir = -parent_plane.target_dir if use_negative_target else parent_plane.target_dir
    
    #rotate to target direction if not close to it
    var not_close_to_target_alignment = (alignment_dir.angle_to(target_dir) > PI/32)
    if not_close_to_target_alignment:
      var prev_rotation = parent_spatial.rotation
      var rotation_vec = alignment_dir.cross(target_dir).normalized()
      parent_spatial.rotate(rotation_vec, delta * rotation_rate * 1.0)
      var rotation_quat = Quat(parent_spatial.rotation)
      var angle_from_original = initial_rotation_quat.angle_to(Quat(rotation_quat)) * 180 / PI
      if (max_angle != -1) and (angle_from_original > max_angle):
        parent_spatial.rotation = prev_rotation #revert the rotation
    
#    #rotate back to max angle if over max angle
#    var angle_from_original = initial_rotation_quat.angle_to(Quat(parent_spatial.rotation)) * 180 / PI
#    var original_alignment_dir = Lib.to_global_vec(parent_spatial.get_parent(), original_local_alignment_dir)
#    if (max_angle != -1) and (angle_from_original > max_angle):
#      var rotation_correction_axis = alignment_dir.cross(original_alignment_dir).normalized()
#      DebugDraw.draw_line(parent_spatial.global_translation, parent_spatial.global_translation + rotation_correction_axis, Color(0.0, 0.0, 1.0))
#      DebugDraw.draw_line(parent_spatial.global_translation, parent_spatial.global_translation + original_alignment_dir, Color(0.0, 1.0, 0.0))
#      print((angle_from_original - max_angle) * delta, ' -> ', min((angle_from_original - max_angle) * delta, 0.1))
#      parent_spatial.rotate(rotation_correction_axis, min((angle_from_original - max_angle) * delta, 0.1))
    
#    #rotate back to max angle if over max angle
#    var rotation_quat = Quat(parent_spatial.rotation)
#    var angle_from_original = initial_rotation_quat.angle_to(Quat(rotation_quat)) * 180 / PI
#    if (max_angle != -1) and (angle_from_original > max_angle):
#      parent_spatial.rotation = rotation_quat.slerp(initial_rotation_quat, 0.1 * delta).get_euler()
    

