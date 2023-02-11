extends Spatial

var speed_boost_scene = preload("res://3d-movesim/level-elements/speed_boost/speedBoost.tscn")

func _on_Area_body_entered(potential_player : PhysicsBody):
  if 'is_player' in potential_player:
    var player = potential_player
    var speed_boost = speed_boost_scene.instance()
    player.add_child(speed_boost)
    self.queue_free()
