extends RayCast

func _input(event : InputEvent):
  if (not event.is_action("activate")) or (not Input.is_action_just_pressed("activate")):
    return
  
  if not is_colliding():
    return
  
  var current_node = get_collider()
  while current_node:
    if current_node.has_method('player_activated'):
      current_node.player_activated(self)
      return
    current_node = current_node.get_parent()
