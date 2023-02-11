extends KinematicBody

var is_player = true

onready var camera : Camera = find_node('Camera')

var velocity : Vector3 = Vector3(0,0,0)
var hor_velocity : Vector3 = Vector3(0,0,0)
var ground_rel_vel : Vector3 = Vector3(0,0,0)

var global_z_dir : Vector3
var global_x_dir : Vector3
var global_y_dir : Vector3

var forward_dir : Vector3
var rightward_dir : Vector3

var touching_ground = false

onready var label = $Label3D

onready var debug_draw_point = get_tree().get_root().find_node('debugDrawPoint')

export(float, 0, 5) var gravity_rate = 9.8

export var draw_velocity = false
export var draw_movement_axes = false
export var show_speedometer = false

var speed_mod = 1

func set_velocity(new_velocity):
  velocity = new_velocity
  hor_velocity = Vector3(velocity.x, 0, velocity.z)

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  if show_speedometer:
    var speedometer = find_node('speedometer')
    speedometer.visible = true

func _input(event):
  if event is InputEventMouseMotion:
    var horizontal = -event.relative.x / 400
    self.rotate_object_local(Vector3(0, 1, 0), horizontal*PI/4)
    var vertical = -event.relative.y / 400
    var cam_z_dir = (camera.to_global(Vector3(0, 0, 1)) - camera.to_global(Vector3(0, 0, 0))).normalized()
    var cam_z_angle = acos(cam_z_dir.dot(Vector3(0, -1, 0))) / PI
    if not ((cam_z_angle < 0.15 and vertical > 0) or (cam_z_angle > 1 - 0.15 and vertical < 0)):
      camera.rotate_object_local(Vector3(1, 0, 0), vertical*PI/4)

func _process(delta):
  if Input.is_action_just_pressed('escape'):
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  
  velocity = velocity + Vector3(0, -gravity_rate * 50, 0) * delta
  if draw_velocity:
    DebugDraw.draw_line(debug_draw_point.global_translation, debug_draw_point.global_translation + velocity, Color(0, 1, 0))
  
  velocity = self.move_and_slide(velocity, Vector3(0, 1, 0))
  touching_ground = is_on_floor()
  
  hor_velocity = Vector3(velocity.x, 0, velocity.z)
  
  if touching_ground:
    var ground_normal = get_floor_normal()
    forward_dir = Lib.vec_rej(global_z_dir, ground_normal).normalized()
    rightward_dir = Lib.vec_rej(global_x_dir, ground_normal).normalized()
    ground_rel_vel = get_floor_velocity()
  else:
    forward_dir = global_z_dir
    rightward_dir = global_x_dir
    ground_rel_vel = Vector3(0, 0, 0)
  
  if draw_movement_axes:
    DebugDraw.draw_line(debug_draw_point.global_translation, debug_draw_point.global_translation + forward_dir, Color(1, 0, 0))
    DebugDraw.draw_line(debug_draw_point.global_translation, debug_draw_point.global_translation + rightward_dir, Color(0, 0, 1)) 
  
  var speed = velocity.length()
  
  global_x_dir = Lib.to_global_vec(self, Vector3(1, 0, 0)).normalized()
  global_y_dir = Lib.to_global_vec(self, Vector3(0, 1, 0)).normalized()
  global_z_dir = Lib.to_global_vec(self, Vector3(0, 0, -1)).normalized()
  
  
  
  
