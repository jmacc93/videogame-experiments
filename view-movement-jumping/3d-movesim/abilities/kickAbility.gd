extends CSGBox

onready var raycast : RayCast = $RayCast
onready var player : KinematicBody = find_parent('player')

export(float, 0, 3) var power = 1.0

func _input(event: InputEvent):
  if Input.is_action_just_pressed("click"):
    var raycast_vec = Lib.to_global_vec(raycast, raycast.cast_to)
    player.velocity += raycast_vec * power
