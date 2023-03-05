extends RichTextLabel

onready var parent = get_parent()

onready var last_position = parent.global_translation

func _process(delta):
  var velocity = (parent.global_translation - last_position) / delta
  text = String(velocity.length())
  last_position = parent.global_translation
