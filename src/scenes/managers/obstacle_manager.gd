extends Node2D

@export var obstacle: PackedScene
@export var obstacle_layer: Node2D
@export var speed: float
@export var min_spawn: float
@export var max_spawn: float
@export var is_flipped: bool = false

@onready var spawn_timer = $SpawnTimer


func _ready():
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	spawn_timer.start()


func spawn_obstacles():
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	var obstacle_instance = obstacle.instantiate()
	obstacle_layer.add_child(obstacle_instance)
	obstacle_instance.global_position = global_position
	obstacle_instance.init(speed)
	if is_flipped:
		obstacle_instance.flip()
	


func _on_spawn_timer_timeout():
	spawn_obstacles()
