extends CanvasLayer

@onready var highscore_label = %HighscoreLabel
@onready var lives_label = %LivesLabel
@onready var score_label = %ScoreLabel
@onready var time_label = %TimeLabel
@onready var game_timer = %GameTimer
@onready var start_delay_timer = %StartDelayTimer

var game_start_wait_time: int


func _ready():
	GameEvents.lives_changed.connect(_on_lives_changed)
	GameEvents.score_changed.connect(_on_score_changed)
	GameEvents.high_score_changed.connect(_on_high_score_changed)
	GameEvents.level_complete.connect(_on_level_complete)
	GameEvents.game_over.connect(_on_game_over)
	#TODO: Countdown to game start to populate obstacles
	
	game_start_wait_time = game_timer.wait_time
	$AnimationPlayer.play("start_delay")
	
	update_score(GameEvents.score)
	update_high_score(GameEvents.high_score)
	update_lives(GameEvents.lives)
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


func update_time(num: int):
	time_label.text = "Time: %02d" % num


func _on_lives_changed(num: int):
	update_lives(num)


func _on_score_changed(num: int):
	update_score(num)


func _on_high_score_changed(num: int):
	update_high_score(num)


func _on_start_delay_timer_timeout():
	GameEvents.start_delay = false
	game_timer.start()


func _on_game_timer_timeout():
	game_timer.wait_time = game_start_wait_time
	GameEvents.game_over.emit()
	GameEvents.reset_game()


func _on_level_complete():
	var time_left:int = game_timer.time_left
	GameEvents.update_score(time_left * 10)
	game_timer.stop()
	game_timer.wait_time -= 30
	start_delay_timer.start()
	$AnimationPlayer.play("start_delay")
	GameEvents.start_delay = true


func _on_game_over():
	game_timer.wait_time = game_start_wait_time
	start_delay_timer.start()
	$AnimationPlayer.play("start_delay")
	GameEvents.start_delay = true
