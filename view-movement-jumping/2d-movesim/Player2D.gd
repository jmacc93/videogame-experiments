extends KinematicBody2D

var is_player = true

onready var camera : Camera = $Camera

var velocity : Vector2 = Vector2(0, 0) setget set_velocity
var hor_velocity : float = 0

var touching_ground = false

#onready var label = $Label3D

onready var ground_touch_area = $groundTouchArea

export(float, 0, 100) var gravity_rate = 9.8

func set_velocity(new_velocity):
  velocity = new_velocity
  hor_velocity = velocity.x

func _ready():
#  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_just_pressed('escape'):
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  
  velocity += Vector2(0, gravity_rate * delta * 100)
  velocity = self.move_and_slide(velocity, Vector2(0, 1))
  hor_velocity = velocity.x
  
  touching_ground = (ground_touch_area.get_overlapping_bodies().size() > 0)
  
