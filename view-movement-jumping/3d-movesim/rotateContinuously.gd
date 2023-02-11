extends Node

export var axis : Vector3 = Vector3(0, 1, 0)
export var rate = 1.0
onready var parent = $'..'

func _ready():
  axis = axis.normalized()

func _process(delta):
  parent.rotate(axis, rate * delta)
