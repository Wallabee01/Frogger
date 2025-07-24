extends Log

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var submerge_timer: Timer = %SubmergeTimer
@onready var reemerge_timer: Timer = %ReemergeTimer


func _ready():
	submerge_timer.wait_time = randf_range(3.0, 10.0)
	reemerge_timer.wait_time = randf_range(1.0, 4.0)
	submerge_timer.start()


func _on_submerge_timer_timeout():
	animation_player.play("submerge")


func _on_reemerge_timer_timeout():
	animation_player.play("reemerge")
