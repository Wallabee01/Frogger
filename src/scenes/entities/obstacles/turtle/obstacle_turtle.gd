extends ObstacleWater

const SUBMERGE_TIME_RANGE: Vector2 = Vector2(3.0, 10.0)
const REEMERGE_TIME_RANGE: Vector2 = Vector2(1.0, 4.0)

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var submerge_timer: Timer = %SubmergeTimer
@onready var reemerge_timer: Timer = %ReemergeTimer


func _ready():
	submerge_timer.wait_time = randf_range(SUBMERGE_TIME_RANGE.x, SUBMERGE_TIME_RANGE.y)
	reemerge_timer.wait_time = randf_range(REEMERGE_TIME_RANGE.x, REEMERGE_TIME_RANGE.y)
	submerge_timer.start()


func _on_submerge_timer_timeout():
	animation_player.play("submerge")


func _on_reemerge_timer_timeout():
	animation_player.play("reemerge")
