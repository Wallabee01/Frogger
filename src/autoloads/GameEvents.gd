extends Node

signal lives_changed(lives)
signal score_changed(score)
signal high_score_changed(high_score)
signal level_complete
signal game_over

const SAVE_FILE_PATH = "user://game.save"

var lives: int = 3
var score: int = 0
var high_score: int = 0
var lilypad_count: int = 0
var start_delay: bool = true


func _ready():
	_load_save_file()
	emit_signal("high_score_changed", high_score)


func _load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH): return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	high_score = file.get_var()


func _save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(high_score)


func update_score(num: int):
	score += num
	emit_signal("score_changed", score)


func update_high_score(num: int):
	high_score += num
	emit_signal("high_score_changed", high_score)


func update_lives(num: int):
	lives += num
	emit_signal("lives_changed", lives)
	
	if lives == 0:
		GameEvents.emit_signal("game_over")
		reset_game()


func update_lilypads(num: int):
	lilypad_count += num
	
	if lilypad_count == 5:
		_level_completed()


func _level_completed():
	lilypad_count = 0
	update_score(1000)
	emit_signal("level_complete")


func reset_game():
	if score > high_score:
		high_score = score
		_save()
	
	lives = 3
	score = 0
	lilypad_count = 0
	
	emit_signal("score_changed", score)
	emit_signal("high_score_changed", high_score)
	emit_signal("lives_changed", lives)
