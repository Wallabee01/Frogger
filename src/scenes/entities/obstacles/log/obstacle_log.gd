class_name ObstacleWater extends Obstacle

var previous_position: Vector2 = Vector2.ZERO
var is_previous_position_set: bool = false

@onready var area_2d = %Area2D


func _ready():
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)


func get_movement_delta() -> Vector2:
	if !is_previous_position_set:
		previous_position = global_position
		is_previous_position_set = true
		return Vector2.ZERO
	
	var delta_move = global_position - previous_position
	previous_position = global_position
	return delta_move


func _on_area_2d_body_entered(body):
	if body.is_in_group("Frogger"):
		body.current_water_obstacle = self


func _on_area_2d_body_exited(body):
	if body.is_in_group("Frogger"):
		if body.current_water_obstacle == self:
			body.current_water_obstacle = null
			is_previous_position_set = false
