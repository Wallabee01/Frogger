extends Area2D

var is_occupied: bool = false

@onready var frogger_sprite_2d: AnimatedSprite2D = $FroggerSprite2D
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var level_complete_stream_player: AudioStreamPlayer = %LevelCompleteStreamPlayer


func _ready():
	Events.game_over.connect(_on_game_over)
	Events.level_complete.connect(_on_level_complete)


func _on_body_entered(body):
	if body.is_in_group("Frogger") && !is_occupied:
		audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
		audio_stream_player.play()
		is_occupied = true
		frogger_sprite_2d.visible = true
		GameManager.update_score(50)
		GameManager.update_lilypads(1)
		body.call_deferred("reset")


func _reset():
	is_occupied = false
	frogger_sprite_2d.visible = false


func _on_game_over():
	_reset()


func _on_level_complete():
	level_complete_stream_player.pitch_scale = randf_range(0.8, 1.2)
	level_complete_stream_player.play()
	_reset()
