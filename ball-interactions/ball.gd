extends Node

var is_ball = true

export(int, 0, 1) var type = 1
var type_count = 2

export(float, 0, 10) var rr_mag = 5
export(float, 0, 10) var rb_mag = 5
export(float, 0, 10) var br_mag = 5
export(float, 0, 10) var bb_mag = 5

func set_type(new_type):
  type = new_type
  match type:
    0:
      $'../Sprite'.modulate = Color(1, 0, 0, 1)
    1:
      $'../Sprite'.modulate = Color(0, 0, 1, 1)

func _ready():
  set_type(type)

func _on_RigidBody2D_body_entered(body):
  var bodyBall = body.get_node('ball')
  
  var vec = Vector2(rand_range(-1, 1), rand_range(-1, 1))
  
  if bodyBall:
    match type:
      0:
        match bodyBall.type:
          0:
            $'..'.apply_central_impulse(rand_range(100, rr_mag*100) * vec)
          1:
            $'..'.apply_central_impulse(rand_range(100, rb_mag*100) * vec)
      1:
        match bodyBall.type:
          0:
            $'..'.apply_central_impulse(rand_range(100, br_mag*100) * vec)
          1:
            $'..'.apply_central_impulse(rand_range(100, bb_mag*100) * vec)

