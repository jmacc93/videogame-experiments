extends Node

onready var player = $'..'

### Ground walking behaviors

var walking = false

export var can_always_walk = false

export(float, 0, 200) var move_rate = 18
export(float, 0, 3) var forward_walk_mult  = 1.0
export(float, 0, 3) var side_walk_mult     = 1.0
export(float, 0, 3) var backward_walk_mult = 1.0

export(float, 0, 10) var air_control_walk_mag = 2.0

export var fric_mult = 1
export var walk_friction = 0.1
export var walk_above_move_rate_friction = 0.15
export var no_walk_friction = 0.3

var frames_touching_ground = 0
export var friction_begin_frames = 5

export var slow_speed_mag_cutoff_speed = 15
export(float, 0, 1) var slow_speed_mag_parameter = 0.2
export(float, 0, 1) var slow_speed_mag_min = 0.2

var slow_speed_mag = slow_speed_mag_min

var last_walk_vec = Vector3(0, 0, 0)

var walk_mod : float = 1.0
var jump_mod : float = 1.0
var friction_mod : float = 1.0

func _process(delta):
  
  var speed = player.hor_velocity.length()
#  slow_speed_mag = slow_speed_mag_min + (1 - slow_speed_mag_min) * pow(min(speed, slow_speed_mag_cutoff_speed) / slow_speed_mag_cutoff_speed, slow_speed_mag_parameter)
  
  var walk_vec = Vector3(0, 0, 0)
  
  var player_speed_mod = player.speed_mod
  
  if Input.is_action_pressed("move_forward"):
    walk_vec +=  player.forward_dir * move_rate * forward_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_backward"):
    walk_vec += -player.forward_dir * move_rate * backward_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_left"):
    walk_vec += -player.rightward_dir * move_rate * side_walk_mult * player_speed_mod
  
  if Input.is_action_pressed("move_right"):
    walk_vec +=  player.rightward_dir * move_rate * side_walk_mult * player_speed_mod
  
  walk_vec *= walk_mod
  
  walking = walk_vec.length() > 0.001
  
  if player.touching_ground:
    if (frames_touching_ground > friction_begin_frames) and (walking or (player.velocity.length() > 0)):
      var fric_power = ((walk_above_move_rate_friction if (player.hor_velocity.length() > move_rate) else walk_friction) if walking else no_walk_friction) * 100 * friction_mod
      player.velocity = player.velocity +  fric_power * (walk_vec - player.hor_velocity) * delta
    else:
      frames_touching_ground += 1
  else:
    frames_touching_ground = 0
    if walking:
      var new_hor_vel = player.hor_velocity + air_control_walk_mag * walk_vec * delta
      var old_energy = player.hor_velocity.length_squared()
      var new_energy = new_hor_vel.length_squared()
      if (new_hor_vel.length() > move_rate) and (new_energy > old_energy):
        player.velocity = player.velocity + (player.hor_velocity.length() * new_hor_vel.normalized() - player.hor_velocity)
      else:
        player.velocity = player.velocity + (new_hor_vel - player.hor_velocity)
  
  last_walk_vec = walk_vec
  
  var min_speed_condition       = (player.hor_velocity.length() < min_wall_walk_speed)
  var touching_ground_condition =  player.touching_ground
  if min_speed_condition or touching_ground_condition:
    left_wall_walking = false
    right_wall_walking = false
    wall_walking = false
  else:
    left_wall_walking = left_wall_touching
    right_wall_walking = right_wall_touching
    wall_walking = left_wall_touching or right_wall_touching

#### Wall walking detection area

onready var camera : Camera = get_parent().find_node("Camera")
onready var left_arm_area : Area = get_parent().find_node("leftArmArea")
onready var right_arm_area : Area = get_parent().find_node("rightArmArea")

onready var left_arm_raycast : RayCast  = left_arm_area.get_node('RayCast')
onready var right_arm_raycast : RayCast = right_arm_area.get_node('RayCast')

export var cam_rotation = 12.5

var left_wall_touching = false
var right_wall_touching = false
var wall_touching = false

var left_wall_walking = false
var right_wall_walking = false
var wall_walking = false

var left_collision_normal : Vector3
var right_collision_normal : Vector3

export var min_wall_walk_speed = 5

func _ready():
  left_arm_area.connect('body_entered', self, '_on_leftArmArea_body_entered')
  left_arm_area.connect('body_exited', self, '_on_leftArmArea_body_exited')
  right_arm_area.connect('body_entered', self, '_on_rightArmArea_body_entered')
  right_arm_area.connect('body_exited', self, '_on_rightArmArea_body_exited')

func reset_wall_touching_state():
  var both_active = left_wall_touching and right_wall_touching
  var camera_z_angle = camera.rotation.z
  camera.rotation.z = 0
  left_collision_normal  = Vector3(0, 0, 0)
  right_collision_normal = Vector3(0, 0, 0)

func update_wall_touching_state():
  wall_touching = left_wall_touching or right_wall_touching
  reset_wall_touching_state()
  
  if left_arm_raycast.is_colliding():
    left_collision_normal = left_arm_raycast.get_collision_normal()
  if right_arm_raycast.is_colliding():
    right_collision_normal = right_arm_raycast.get_collision_normal()
  
  var both_active = left_wall_touching and right_wall_touching
  if both_active:
    return
  
  if left_wall_touching:
    camera.rotation.z = cam_rotation
    return
  
  if right_wall_touching:
    camera.rotation.z = -cam_rotation
    return

func _on_rightArmArea_body_entered(body):
  right_wall_touching = true
  update_wall_touching_state()

func _on_rightArmArea_body_exited(body):
  right_wall_touching = false
  update_wall_touching_state()

func _on_leftArmArea_body_entered(body):
  left_wall_touching = true
  update_wall_touching_state()

func _on_leftArmArea_body_exited(body):
  left_wall_touching = false
  update_wall_touching_state()





