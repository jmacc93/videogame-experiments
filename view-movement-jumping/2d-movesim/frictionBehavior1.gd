extends Node

onready var player : KinematicBody2D = get_parent()

export var friction_power : float = 0.1

func _process(delta):
  
  if player.touching_ground:
    var adj_friction_power = friction_power * 100
    player.velocity = player.velocity - Vector2(adj_friction_power * player.hor_velocity * delta, 0)
