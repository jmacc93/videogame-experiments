extends Node

onready var parent : Airplane = Lib.get_parent_with_class(self, Airplane)

export var target_spatial_path : NodePath
onready var target_spatial : Spatial = get_node(target_spatial_path)

export var show_rotation_vector = false

export var power = 1.0

func _physics_process(delta):
  if target_spatial:
    var target_dir = (target_spatial.global_translation - parent.global_translation).normalized()
    var z_dir = Lib.to_global_vec(parent, Vector3(0, 0, -1))
    if target_dir.angle_to(z_dir) > PI/8:
      var rotation_vector = z_dir.cross(target_dir).normalized()
      if show_rotation_vector:
        DebugDraw.draw_line(parent.global_translation, parent.global_translation + rotation_vector * 10, Color(0.0, 1.0, 1.0))
      parent.target_dir = target_dir
#      parent.add_torque(rotation_vector * power * delta * 10000)
