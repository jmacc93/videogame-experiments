extends Timer

func _on_Timer_timeout():
  var player = get_node('..').get_node('..')
  if player.is_player:
    player.speed_mod = 1
