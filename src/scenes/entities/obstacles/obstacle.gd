class_name Obstacle extends RigidBody2D

var is_flipped: bool = false


func _process(_delta):
	if is_flipped:
		if global_position.x < -32.0:
			queue_free()
	else:
		if global_position.x > 640.0 + 32.0:
			queue_free()


func init(speed: float, flipped: bool):
	linear_velocity = Vector2(speed, 0.0)
	is_flipped = flipped
	
	if flipped:
		_flip()


func _flip():
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = true
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = true
	if has_node("GPUParticles2D"):
		$GPUParticles2D.position.x = -$GPUParticles2D.position.x
