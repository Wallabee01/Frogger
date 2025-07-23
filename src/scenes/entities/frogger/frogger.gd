extends CharacterBody2D

const GRID_SIZE: float = 16
const TWEEN_DURATION: float = 0.1
const START_POSITION: Vector2 = Vector2(312.0, 352.0)

var is_moving: bool = false
var target_position: Vector2
var current_log: Node2D = null
var is_in_water: bool = false
var is_resetting: bool = false
var tween

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	print(global_position)
	target_position = position


func _physics_process(_delta):
	if is_resetting:
		is_resetting = false
		return
	
	if is_moving:
		return

	var input_dir: Vector2 = get_input_direction()
	if input_dir != Vector2.ZERO:
		var new_position = (global_position + input_dir * GRID_SIZE)
		if is_position_valid(new_position):
			start_move_to(new_position)
			position = position.snapped(Vector2(16, 16))
	
	if current_log != null and current_log.has_method("get_movement_delta"):
		global_position += current_log.get_movement_delta()
	
	if is_in_water && current_log == null && !is_resetting:
		died()


func get_input_direction() -> Vector2:
	if Input.is_action_just_pressed("move_up"):
		sprite_2d.rotation_degrees = 0
		return Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		sprite_2d.rotation_degrees = 180
		return Vector2.DOWN
	elif Input.is_action_just_pressed("move_left"):
		sprite_2d.rotation_degrees = 270
		return Vector2.LEFT
	elif Input.is_action_just_pressed("move_right"):
		sprite_2d.rotation_degrees = 90
		return Vector2.RIGHT
	return Vector2.ZERO


func died():
	#TODO: Lives
	reset()

func reset():
	if tween and tween.is_valid():
		tween.kill()
		tween = null
		is_moving = false
	position = Vector2.ZERO
	global_position = START_POSITION
	sprite_2d.rotation_degrees = 0
	velocity = Vector2.ZERO
	is_resetting = true
	is_in_water = false
	current_log = null


func is_position_valid(_pos: Vector2) -> bool:
	# Optional logic: boundaries, obstacles, etc.
	return true


func start_move_to(new_pos: Vector2):
	is_moving = true
	target_position = new_pos
	tween = create_tween()
	tween.tween_property(self, "position", target_position, TWEEN_DURATION)
	tween.finished.connect(_on_tween_complete)


func _on_tween_complete():
	is_moving = false


func _on_death_area_2d_body_entered(_body):
	died()
