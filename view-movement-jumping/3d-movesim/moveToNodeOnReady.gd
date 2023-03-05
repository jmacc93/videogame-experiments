extends Node

export var new_parent_search_string: String
onready var node_to_move = $'..'
var new_parent

func _ready():
  assert(new_parent_search_string)
  var search_array = new_parent_search_string.split('>>')
  
#  var new_parent
  if search_array.size() == 1:
    var child_search_string = search_array[0].strip_edges()
    node_to_move.get_parent().find_node(child_search_string)
  else:
    var parent_search_string = search_array[0].strip_edges()
    var child_search_string  = search_array[1].strip_edges()
    var parent = node_to_move.find_parent(parent_search_string)
    assert(parent)
    new_parent = parent.find_node(child_search_string)
  assert(new_parent)
  print(new_parent, ' ', node_to_move)
  
  call_deferred('reparent', node_to_move, new_parent)
  self.queue_free()
  
func reparent(node, new_parent):
  node_to_move.get_parent().remove_child(node_to_move)
  new_parent.add_child(node_to_move)
  
