extends RayCast

export var power_mod     = 1.0
export var normal_power  = 1.0
export var tangent_power = 0.1

onready var rigid_body = Lib.get_parent_with_class(self, RigidBody)

onready var last_position = global_translation

export var disabled = false

export var show_force_lines = false

export var use_square_velocity = true

func _physics_process(delta):
  if not disabled:
    var velocity = (global_translation - last_position) / delta
    
    var normal_dir = Lib.to_global_vec(self, cast_to).normalized()
    var normal_velocity  = Lib.vec_proj(velocity, normal_dir)
    var tangent_velocity = Lib.vec_rej(velocity, normal_dir)
    
    var normal_air_resistance_force = normal_velocity * (normal_velocity.length() if use_square_velocity else 1.0) * normal_power
    var tangent_air_resistance_force = tangent_velocity * (tangent_velocity.length() if use_square_velocity else 1.0) * normal_power
    var air_resistance_force = -(normal_air_resistance_force + tangent_air_resistance_force) * power_mod * 0.01
    rigid_body.add_force(air_resistance_force * delta, self.global_translation - rigid_body.global_translation)
    if show_force_lines:
      DebugDraw.draw_line(global_translation, global_translation + normal_air_resistance_force, Color(1.0, 0.0, 0.0))
      DebugDraw.draw_line(global_translation, global_translation + tangent_air_resistance_force, Color(0.0, 1.0, 0.0))
  
  last_position = global_translation
