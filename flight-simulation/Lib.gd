extends Node

static func to_global_vec(obj : Spatial, vec : Vector3):
  return obj.to_global(vec) - obj.global_translation

static func local_to_local_vec(origin_object : Spatial, target_object : Spatial, vec : Vector3):
  var global_vec = to_global_vec(origin_object, vec)
  return target_object.to_local(global_vec + target_object.global_translation)

var last_delta = 1.0

func _process(delta):
  last_delta = delta

func vec_proj(a: Vector3, b: Vector3):
  var r = b.length_squared()
  if r != 0:
    return b * (a.dot(b) / r)
  else:
    return Vector3(0, 0, 0)

func vec_rej(a: Vector3, b: Vector3):
  return a - vec_proj(a, b)

func get_parent_with_class(start_node, class_type):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node is class_type:
      return current_node
    else:
      current_node = current_node.get_parent()
  return null
