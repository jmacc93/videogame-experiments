extends CSGBox

onready var raycast : RayCast = $RayCast
onready var player : KinematicBody = find_parent('player')

func _input(event: InputEvent):
  if Input.is_action_just_pressed("click"):
    var raycast_vec = Lib.to_global_vec(raycast, raycast.cast_to)
    player.move_and_collide(raycast_vec)
