extends CharacterBody2D

const GRID_SIZE: float = 16
const TWEEN_DURATION: float = 0.1

var is_moving: bool = false
var target_position: Vector2


func _ready():
	target_position = position


func _process(_delta):
	if is_moving:
		return

	var input_dir: Vector2 = get_input_direction()
	if input_dir != Vector2.ZERO:
		var new_position = (target_position + input_dir * GRID_SIZE)
		if is_position_valid(new_position):
			start_move_to(new_position)


func get_input_direction() -> Vector2:
	if Input.is_action_just_pressed("move_up"):
		return Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		return Vector2.DOWN
	elif Input.is_action_just_pressed("move_left"):
		return Vector2.LEFT
	elif Input.is_action_just_pressed("move_right"):
		return Vector2.RIGHT
	return Vector2.ZERO


func is_position_valid(pos: Vector2) -> bool:
	# Optional logic: boundaries, obstacles, etc.
	return true


func start_move_to(new_pos: Vector2):
	is_moving = true
	target_position = new_pos
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, TWEEN_DURATION)
	tween.finished.connect(_on_tween_complete)


func _on_tween_complete():
	is_moving = false
