extends Node

export var speed_mod = 2
export var delay = 2

func _ready():
  var player = $'..'
  if player.is_player:
    player.speed_mod = speed_mod
  $Timer.wait_time = delay
  $Timer.start()
