extends CharacterBody2D

const GRID_SIZE: int = 16
const MOVE_TWEEN_DURATION: float = 0.1
const START_POSITION: Vector2 = Vector2(312.0, 352.0)
const DEATH_SFX: AudioStream = preload("res://assets/audio/sfx/death.wav")
const DEATH_WATER_SFX: AudioStream = preload("res://assets/audio/sfx/death_water.ogg")

var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var is_in_water: bool = false
var is_resetting: bool = false
var current_water_obstacle: Node2D = null
var move_tween: Tween = null

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_area_2d: Area2D = %DeathArea2D
@onready var death_particles_2d: GPUParticles2D = %DeathParticles2D
@onready var death_stream_player: AudioStreamPlayer = %DeathStreamPlayer
@onready var jump_stream_player: AudioStreamPlayer = %JumpStreamPlayer
@onready var game_over_stream_player: AudioStreamPlayer = %GameOverStreamPlayer


func _ready():
	target_position = global_position
	Events.game_over.connect(_on_game_over)


func _physics_process(_delta):
	if GameManager.start_delay: return
	if is_moving: return
	if is_resetting:
		return
	
	var input_dir: Vector2 = get_input_direction()
	if input_dir != Vector2.ZERO:
		var new_position = (global_position + input_dir * GRID_SIZE)
		start_move_to(new_position)
		global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	
	if current_water_obstacle != null and current_water_obstacle.has_method("get_movement_delta"):
		global_position += current_water_obstacle.get_movement_delta()
	
	if is_in_water && current_water_obstacle == null && !is_resetting:
		died(true)


func get_input_direction() -> Vector2:
	if Input.is_action_just_pressed("move_up"):
		sprite_2d.rotation_degrees = 0
		jump_stream_player.pitch_scale = randf_range(0.8, 1.2)
		jump_stream_player.play()
		GameManager.update_score(10)
		return Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		sprite_2d.rotation_degrees = 180
		jump_stream_player.pitch_scale = randf_range(0.8, 1.2)
		jump_stream_player.play()
		return Vector2.DOWN
	elif Input.is_action_just_pressed("move_left"):
		sprite_2d.rotation_degrees = 270
		jump_stream_player.pitch_scale = randf_range(0.8, 1.2)
		jump_stream_player.play()
		return Vector2.LEFT
	elif Input.is_action_just_pressed("move_right"):
		sprite_2d.rotation_degrees = 90
		jump_stream_player.pitch_scale = randf_range(0.8, 1.2)
		jump_stream_player.play()
		return Vector2.RIGHT
	return Vector2.ZERO


func died(in_water: bool):
	GameManager.update_lives(-1)
	
	if !in_water:
		death_stream_player.stream = DEATH_SFX
	else:
		death_stream_player.stream = DEATH_WATER_SFX
	death_stream_player.pitch_scale = randf_range(0.8, 1.2)
	death_stream_player.play()
	
	is_resetting = true
	death_particles_2d.emitting = true
	death_area_2d.set_deferred("monitoring", false)
	await death_particles_2d.finished
	
	reset()


func reset():
	if move_tween and move_tween.is_valid():
		move_tween.kill()
		move_tween = null
		is_moving = false
	position = Vector2.ZERO
	global_position = START_POSITION
	sprite_2d.rotation_degrees = 0
	velocity = Vector2.ZERO
	is_resetting = false
	is_in_water = false
	death_area_2d.set_deferred("monitoring", true)
	current_water_obstacle = null


func start_move_to(new_pos: Vector2):
	is_moving = true
	target_position = new_pos
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_position, MOVE_TWEEN_DURATION)
	move_tween.finished.connect(_on_tween_complete)


func _on_tween_complete():
	is_moving = false


func _on_death_area_2d_body_entered(_body):
	died(false)


func _on_game_over():
	game_over_stream_player.pitch_scale = randf_range(0.8, 1.2)
	game_over_stream_player.play()
	await death_particles_2d.finished
	reset()
