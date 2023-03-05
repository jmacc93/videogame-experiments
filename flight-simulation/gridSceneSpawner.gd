extends Spatial

export var disabled = false

export var generate_around_path : NodePath
onready var generate_around : Spatial = get_node(generate_around_path)

export var template_scene : PackedScene

export var cell_size : int = 1

const delete_when_far_script : Resource = preload('res://deleteWhenFar.gd')

const generated_objects : Dictionary  = {}

var last_generation_seed

onready var good_to_go = (generate_around and template_scene and delete_when_far_script)
