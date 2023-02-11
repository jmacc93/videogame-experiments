extends Spatial

export var one_shot = false
export var wait_time = 1
export var max_count = 10
var count = 0

export var fling_magnitude = 0

export var scene_resource : PackedScene

func _ready():
  $Timer.one_shot = one_shot
  $Timer.wait_time = wait_time
  $Timer.start()

func _on_Timer_timeout():
  if scene_resource:
    var new_node = scene_resource.instance() as Spatial
    assert(new_node)
    var parent = get_parent()
    parent.add_child(new_node)
    new_node.translation = translation
    var node_as_rigid_body = new_node as RigidBody
    if node_as_rigid_body:
      node_as_rigid_body.apply_central_impulse(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)) * fling_magnitude)
    count += 1
    if count > max_count:
      $Timer.stop()
