extends Node

onready var parent : Spatial = Lib.get_parent_with_class(self, Spatial)

export var action : String

export var active_on_released = true

func _input(event: InputEvent):
  var pressed = Input.is_action_just_pressed(action)
  var released = Input.is_action_just_released(action)
  if parent and action and (pressed or released):
    var active = released if active_on_released else pressed
    if parent is MeshInstance:
      parent.visible = active
    elif parent is CollisionShape:
      parent.disabled = active
    elif ('disable' in parent):
      parent.disable = active
    elif ('disabled' in parent):
      parent.disabled = active
