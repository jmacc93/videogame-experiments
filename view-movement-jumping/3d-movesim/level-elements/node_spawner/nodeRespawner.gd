extends Spatial

export var respawn_delay = 1.0
var last_detected_time = 0

export var spatialToRespawn : PackedScene
var watched_spatial : Spatial

func _process(delta):
  if not spatialToRespawn:
    return
  
  var current_time = OS.get_ticks_msec()
  var node_existence_condition = watched_spatial and is_instance_valid(watched_spatial) and (not watched_spatial.is_queued_for_deletion())
  if node_existence_condition:
    last_detected_time = current_time
    return
  #past this point we're just waiting for the respawn time to elapse
  
  var respawn_time_condition = last_detected_time + respawn_delay * 1000 < current_time
  if respawn_time_condition:
    watched_spatial = spatialToRespawn.instance() as Spatial
    get_tree().get_root().add_child(watched_spatial)
    watched_spatial.global_translation = global_translation
