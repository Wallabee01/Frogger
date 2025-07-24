extends Area2D

var is_full: bool = false

@onready var frogger_sprite_2d = $FroggerSprite2D
@onready var audio_stream_player = %AudioStreamPlayer
@onready var level_complete_stream_player = %LevelCompleteStreamPlayer


func _ready():
	GameEvents.game_over.connect(_on_game_over)
	GameEvents.level_complete.connect(_on_level_complete)


func _on_body_entered(body):
	if body.is_in_group("Frogger") && !is_full:
		audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
		audio_stream_player.play()
		is_full = true
		frogger_sprite_2d.visible = true
		GameEvents.update_score(50)
		GameEvents.update_lilypads(1)
		body.call_deferred("reset")


func _reset():
	is_full = false
	frogger_sprite_2d.visible = false


func _on_game_over():
	_reset()


func _on_level_complete():
	level_complete_stream_player.pitch_scale = randf_range(0.8, 1.2)
	level_complete_stream_player.play()
	_reset()
