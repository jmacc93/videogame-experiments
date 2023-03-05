extends Node


onready var spatial_parent : Spatial = Lib.get_parent_with_class(self, Spatial)

var positions : Array
export var num_of_positions = 1000

func _process(delta):
  if spatial_parent:
    positions.push_back(spatial_parent.global_translation)
    if (positions.size() > num_of_positions) and (num_of_positions != -1):
      positions.pop_front()
    for i in range(0, positions.size() - 1):
      DebugDraw.draw_line(positions[i], positions[i+1])
