extends Resource

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

var gen_sphere = preload('res://generic_sphere.tres')

func drawline(node: Node, from: Vector3, to: Vector3):
  var drawchild = node.get_node('./_drawHost')
  if drawchild == null:
    drawchild = Spatial.new()
    drawchild.name = '_drawHost'
    node.add_child(drawchild)
  for child in drawchild.get_children():
    child.queue_free()
  var u = 0
  while u < 1:
    u += 0.02
    var lineelem := MeshInstance.new()
    drawchild.add_child(lineelem)
    lineelem.global_translation = from + (to - from) * u
    lineelem.scale = Vector3(0.1, 0.1, 0.1)
    lineelem.mesh = gen_sphere 
#    label.set_text(String(from + (to - from) * u) + ', ' + String(lineelem.global_translation))

static func to_global_vec3(spatial: Spatial, vec: Vector3):
  return (spatial.to_global(vec) - spatial.to_global(Vector3(0, 0, 0))).normalized()
