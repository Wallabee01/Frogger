extends Obstacle
class_name Log

var previous_position: Vector2
var initialized := false

func _ready():
	previous_position = global_position


func get_movement_delta() -> Vector2:
	if not initialized:
		previous_position = global_position
		initialized = true
		return Vector2.ZERO
	
	var delta_move = global_position - previous_position
	previous_position = global_position
	return delta_move


func _on_area_2d_body_entered(body):
	if body.is_in_group("Frogger"):
		body.current_log = self


func _on_area_2d_body_exited(body):
	if body.is_in_group("Frogger"):
		if body.current_log == self:
			body.current_log = null
