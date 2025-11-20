extends Node

const SAVE_FILE_PATH: String = "user://game.save"

var lives: int = 3
var score: int = 0
var high_score: int = 0
var lilypad_count: int = 0
var start_delay: bool = true


func _ready():
	_load_save_file()
	Events.high_score_changed.emit(high_score)


func _load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH): return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	high_score = file.get_var()


func _save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(high_score)


func update_score(num: int):
	score += num
	Events.score_changed.emit(score)


func update_high_score(num: int):
	high_score += num
	Events.high_score_changed.emit(high_score)


func update_lives(num: int):
	lives += num
	Events.lives_changed.emit(lives)
	
	if lives == 0:
		Events.game_over.emit()
		reset_game()


func update_lilypads(num: int):
	lilypad_count += num
	
	if lilypad_count == 5:
		_level_completed()


func _level_completed():
	lilypad_count = 0
	update_score(1000)
	Events.level_complete.emit()


func reset_game():
	if score > high_score:
		high_score = score
		_save()
	
	lives = 3
	score = 0
	lilypad_count = 0
	
	Events.score_changed.emit(score)
	Events.high_score_changed.emit(high_score)
	Events.lives_changed.emit(lives)
