extends Spatial

export(float, 0, 100) var bounce_force = 10

func _on_Area_body_entered(body):
  if 'is_player' in body:
    body.velocity.y += bounce_force * 10
