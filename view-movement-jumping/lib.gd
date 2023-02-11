extends Node

static func to_global_vec(obj : Spatial, vec : Vector3) -> Vector3:
  return obj.to_global(vec) - obj.to_global(Vector3(0, 0, 0))

static func vec_proj(a: Vector3, b: Vector3):
  var bdotb = b.dot(b)
  if bdotb == 0:
    return Vector3(0, 0, 0)
  else:
    return b * a.dot(b) / bdotb

static func vec_projc(a: Vector3, b: Vector3):
  return a.dot(b.normalized())

static func vec_rej(a: Vector3, b: Vector3):
  return a - vec_proj(a, b)

var gen_sphere = preload('res://3d-movesim/generic_sphere.tres')
