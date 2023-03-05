extends Node

func _ready():
  var parent = get_parent()
  var grandparent = Lib.get_parent_with_class(parent, CollisionObject)
  for child in parent.get_children():
    if child is CollisionShape:
      parent.call_deferred('remove_child', child)
      grandparent.call_deferred('add_child', child)
