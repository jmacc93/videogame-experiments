extends Node

export var mouse_captured = true

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent):
  if Input.is_action_just_pressed("toggle_mouse_capture"):
    mouse_captured = not mouse_captured
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE
