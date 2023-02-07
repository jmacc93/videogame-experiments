extends Node2D

var test_obj : RigidBody2D

func _ready():
	test_obj = get_node('./testObject')

func _on_cameraFollowsMouse_child_entered_tree(node):
	if node.name.begins_with('clickPosition'):
		var pos = node.position
		print(get_world_2d().direct_space_state.intersect_point(node.position, 1, []))
