extends Area2D

@onready var frogger_sprite_2d = $FroggerSprite2D

var is_full: bool = false

func _on_body_entered(body):
	if body.is_in_group("Frogger") && !is_full:
		#TODO: Add Score
		is_full = true
		frogger_sprite_2d.visible = true
		body.call_deferred("reset")
