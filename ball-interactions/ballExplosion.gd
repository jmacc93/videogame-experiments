extends Node2D

export(int, 1, 1000) var ball_count = 10
export(float, 0, 10) var explosion_magnitude = 4

func _ready():
  var ball_res = load('res://Ball.tscn')
  
  for i in range(0, ball_count):
    var new_ball : RigidBody2D = ball_res.instance()
    var type_choice = randi() % new_ball.get_node('ball').type_count
    new_ball.get_node('ball').set_type(type_choice)
    add_child(new_ball)
    new_ball.apply_central_impulse(rand_range(0, explosion_magnitude*1000) * Vector2(rand_range(-1, 1), rand_range(-1, 1)))
