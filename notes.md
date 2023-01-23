
These are miscellaneous notes that may help others

---

```
Vector3 move_and_slide_with_snap(linear_velocity, snap, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)
```
`up_direction` defaults to `Vector2(0, 0)`

> If infinite_inertia is true, body will be able to push RigidBody2D nodes, but it won't also detect any collisions with them. If false, it will interact with RigidBody2D nodes like with StaticBody2D.

> If the body collides, it will change direction a maximum of max_slides times before it stops.

> If stop_on_slope is true, body will not slide on slopes when you include gravity in linear_velocity and the body is standing still.

> up_direction is the up direction, used to determine what is a wall and what is a floor or a ceiling. If set to the default value of Vector2(0, 0), everything is considered a wall. This is useful for topdown games.

> floor_max_angle is the maximum angle (in radians) where a slope is still considered a floor (or a ceiling), rather than a wall. The default value equals 45 degrees.

The `snap` vector is apparently like a ray projected from the surface (?) of an object that, if it touches anything, you snap to that thing

