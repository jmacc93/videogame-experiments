extends KinematicBody

var is_player = true

onready var camera : Camera = $Camera

var velocity : Vector3 = Vector3(0,0,0)
var hor_velocity : Vector3 = Vector3(0,0,0)

var global_z_dir : Vector3
var global_x_dir : Vector3
var global_y_dir : Vector3

var touching_ground = false

onready var label = $Label3D

onready var ground_touch_area = $groundTouchArea

export(float, 0, 100) var gravity_rate = 9.8

func set_velocity(new_velocity):
  velocity = new_velocity

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
  if event is InputEventMouseMotion:
    var horizontal = -event.relative.x / 400
    self.rotate_object_local(Vector3(0, 1, 0), horizontal*PI/4)
    var vertical = -event.relative.y / 400
    var cam_z_dir = (camera.to_global(Vector3(0, 0, 1)) - camera.to_global(Vector3(0, 0, 0))).normalized()
    var cam_z_angle = acos(cam_z_dir.dot(Vector3(0, -1, 0))) / PI
    if not ((cam_z_angle < 0.15 and vertical > 0) or (cam_z_angle > 1 - 0.15 and vertical < 0)):
      camera.rotate_object_local(Vector3(1, 0, 0), vertical*PI/4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_just_pressed('escape'):
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  
  velocity = velocity + Vector3(0, -gravity_rate, 0) * delta
  velocity = self.move_and_slide(velocity, Vector3(0, 1, 0))
  
  hor_velocity = Vector3(velocity.x, 0, velocity.z)
  
  touching_ground = (ground_touch_area.get_overlapping_bodies().size() > 0)
  
  var speed = velocity.length()
  
  var cam_z_dir = (camera.to_global(Vector3(0, 0, -1)) - camera.to_global(Vector3(0, 0, 0))).normalized()
  global_z_dir = (to_global(Vector3(0, 0, -1)) - to_global(Vector3(0, 0, 0))).normalized()
  global_x_dir = (to_global(Vector3(1, 0, 0)) - to_global(Vector3(0, 0, 0))).normalized()
  global_y_dir = (to_global(Vector3(0, 1, 0)) - to_global(Vector3(0, 0, 0))).normalized()
  
  
