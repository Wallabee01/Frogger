extends RigidBody2D
class_name Obstacle


func init(speed: float):
		linear_velocity = Vector2(-speed, 0.0)


func flip_sprite():
	$Sprite2D.flip_h = true
