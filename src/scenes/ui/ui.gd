extends CanvasLayer

@onready var score_label: Label = %ScoreLabel
@onready var highscore_label: Label = %HighscoreLabel
@onready var time_label: Label = %TimeLabel
@onready var lives_label: Label = %LivesLabel
@onready var game_timer: Timer = %GameTimer
@onready var start_delay_timer: Timer = %StartDelayTimer


func _ready():
	Events.lives_changed.connect(_on_lives_changed)
	Events.score_changed.connect(_on_score_changed)
	Events.high_score_changed.connect(_on_high_score_changed)
	Events.level_complete.connect(_on_level_complete)
	Events.game_over.connect(_on_game_over)
	
	$AnimationPlayer.play("start_delay")
	
	update_score(GameManager.score)
	update_high_score(GameManager.high_score)
	update_lives(GameManager.lives)
	update_time(game_timer.wait_time)


func _process(_delta):
	if start_delay_timer.is_stopped():
		update_time(game_timer.time_left)


func update_score(num: int):
	score_label.text = "Score: " + str(num)


func update_high_score(num: int):
	highscore_label.text = "High Score: " + str(num)


func update_lives(num: int):
	lives_label.text = "Lives: " + str(num)


func update_time(num: float):
	time_label.text = "Time: %02d" % num


func _on_lives_changed(num: int):
	update_lives(num)


func _on_score_changed(num: int):
	update_score(num)


func _on_high_score_changed(num: int):
	update_high_score(num)


func _on_start_delay_timer_timeout():
	GameManager.start_delay = false
	game_timer.start()


func _on_game_timer_timeout():
	game_timer.stop()
	update_time(game_timer.wait_time)
	Events.game_over.emit()
	GameManager.reset_game()


func _on_level_complete():
	var time_left: int = int(game_timer.time_left)
	GameManager.update_score(time_left * 10)
	game_timer.stop()
	game_timer.wait_time -= 30
	start_delay_timer.start()
	$AnimationPlayer.play("start_delay")
	GameManager.start_delay = true


func _on_game_over():
	game_timer.stop()
	update_time(game_timer.wait_time)
	start_delay_timer.start()
	$AnimationPlayer.play("start_delay")
	GameManager.start_delay = true
