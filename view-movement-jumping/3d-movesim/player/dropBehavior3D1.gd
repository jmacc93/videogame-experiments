extends Node

var drop_count = 0
export var max_drop_count = 1

export(float, 0, 10) var drop_force = 1

var last_drop_time = 0
export(float, 0, 10) var max_drop_rate = 0.5

export var autodrop = false

export var debug_print_drops = false

func _process(delta):
  
  var player = $'..'
  
  if player.touching_ground:
    drop_count = 0
  
  else:
    if Input.is_action_just_pressed('drop') or (autodrop and Input.is_action_pressed("drop")):
      var current_time = float(OS.get_ticks_msec()) / 1000
      if (drop_count < max_drop_count) and (last_drop_time + max_drop_rate < current_time):
        last_drop_time = current_time
        if debug_print_drops:
          print('dropped! at ', last_drop_time, ' (', 'ldt ', last_drop_time, ', mdr ', max_drop_rate, ')')
        if player.velocity.y > 0:
          player.velocity.y = 0
        player.velocity += Vector3(0, -drop_force * 50, 0)
        drop_count += 1
  
