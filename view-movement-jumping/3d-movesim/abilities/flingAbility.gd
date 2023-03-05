  

extends CSGBox

onready var player : KinematicBody = find_parent('player')

var last_mouse_movement : Vector2

export(float, 0, 20) var power = 4

var last_delta

#which direction should mouse-up (mouse y) fling you?
enum Y_type {Y, Z, ZERO} #Y_type.Y  -->  mouse y flings in y dir
export(Y_type) var y_type = Y_type.Y

func _input(event: InputEvent):
  if event is InputEventMouseMotion:
    last_mouse_movement = event.relative
    if Input.is_action_pressed("click"):
      
      var x_dir = Lib.to_global_vec(self, Vector3(1,  0, 0)).normalized()
      var y_dir = Lib.to_global_vec(self, Vector3(0, -1, 0)).normalized()
      var z_dir = Lib.to_global_vec(self, Vector3(0,  0, 1)).normalized()
      
      var adjusted_mouse_vec = last_mouse_movement.normalized() * log(last_mouse_movement.length()) / 8
      
      #which direction should mouse-up (mouse y) fling you?
      var y_vec
      match y_type:
        Y_type.Y:
          y_vec = y_dir
        Y_type.Z:
          y_vec = z_dir
        Y_type.ZERO:
          y_vec = Vector3.ZERO
      
      var mouse_x_vec = (last_mouse_movement.x * x_dir + last_mouse_movement.y * y_vec) * power
      player.velocity += mouse_x_vec * last_delta

func _process(delta):
  last_delta = delta
