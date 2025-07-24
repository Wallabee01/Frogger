extends RigidBody2D
class_name Obstacle


func init(speed: float):
		linear_velocity = Vector2(-speed, 0.0)


func flip():
	$Sprite2D.flip_h = true
	if has_node("GPUParticles2D"):
		$GPUParticles2D.position.x = -$GPUParticles2D.position.x
