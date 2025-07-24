extends Node


func _ready():
	pass
	#TODO: Countdown to game start to populate obstacles


func _on_water_area_2d_body_entered(body):
	if body.is_in_group("Frogger"):
		body.is_in_water = true


func _on_water_area_2d_body_exited(body):
	if body.is_in_group("Frogger"):
		body.is_in_water = false


func _on_walls_body_entered(body):
	if body.is_in_group("Frogger"):
		body.died()
