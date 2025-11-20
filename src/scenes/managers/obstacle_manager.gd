extends Node2D

enum OBSTACLE_TYPE_ENUM { CAR, CAT, SNAKE, LOG, TURTLE }

const CAR_SCENE: PackedScene = preload("res://src/scenes/entities/obstacles/cars/obstacle_car.tscn")
const CAT_SCENE: PackedScene = preload("res://src/scenes/entities/obstacles/cat/obstacle_cat.tscn")
const SNAKE_SCENE: PackedScene = preload("res://src/scenes/entities/obstacles/snake/obstacle_snake.tscn")
const LOG_SCENE: PackedScene = preload("res://src/scenes/entities/obstacles/log/obstacle_log.tscn")
const TURTLE_SCENE: PackedScene = preload("res://src/scenes/entities/obstacles/turtle/obstacle_turtle.tscn")

const OBSTACLE_SCENE_DICT: Dictionary = {
	OBSTACLE_TYPE_ENUM.CAR: CAR_SCENE,
	OBSTACLE_TYPE_ENUM.CAT: CAT_SCENE,
	OBSTACLE_TYPE_ENUM.SNAKE: SNAKE_SCENE,
	OBSTACLE_TYPE_ENUM.LOG: LOG_SCENE,
	OBSTACLE_TYPE_ENUM.TURTLE: TURTLE_SCENE
}

const SPEED_DICT: Dictionary = {
	OBSTACLE_TYPE_ENUM.CAR: 100.0,
	OBSTACLE_TYPE_ENUM.CAT: 75.0,
	OBSTACLE_TYPE_ENUM.SNAKE: 90.0,
	OBSTACLE_TYPE_ENUM.LOG: 60.0,
	OBSTACLE_TYPE_ENUM.TURTLE: 50.0
}

const SPAWN_TIME_RANGE_DICT: Dictionary = {
	OBSTACLE_TYPE_ENUM.CAR: Vector2(0.4, 3.5),
	OBSTACLE_TYPE_ENUM.CAT: Vector2(0.8, 7.0),
	OBSTACLE_TYPE_ENUM.SNAKE: Vector2(2.0, 7.5),
	OBSTACLE_TYPE_ENUM.LOG: Vector2(1.5, 7.0),
	OBSTACLE_TYPE_ENUM.TURTLE: Vector2(2.0, 7.0)
}

@export var obstacle_type: OBSTACLE_TYPE_ENUM = OBSTACLE_TYPE_ENUM.CAR
@export var is_flipped: bool = false

var obstacle_scene: PackedScene = null
var speed: float = 0.0
var spawn_time_range: Vector2 = Vector2.ZERO
var obstacle_parent: Node2D = null

@onready var spawn_timer = $SpawnTimer
@onready var obstacles_above_parent: Node2D = get_node("/root/Game/ObstaclesAbove")
@onready var obstacles_below_parent: Node2D = get_node("/root/Game/ObstaclesBelow")
@onready var obstacle_parent_dict: Dictionary = {
	OBSTACLE_TYPE_ENUM.CAR: obstacles_above_parent,
	OBSTACLE_TYPE_ENUM.CAT: obstacles_above_parent,
	OBSTACLE_TYPE_ENUM.SNAKE: obstacles_above_parent,
	OBSTACLE_TYPE_ENUM.LOG: obstacles_below_parent,
	OBSTACLE_TYPE_ENUM.TURTLE: obstacles_below_parent
}

func _ready():
	obstacle_scene = OBSTACLE_SCENE_DICT[obstacle_type]
	spawn_time_range = SPAWN_TIME_RANGE_DICT[obstacle_type]
	obstacle_parent = obstacle_parent_dict[obstacle_type]
	if is_flipped:
		speed = -SPEED_DICT[obstacle_type]
	else:
		speed = SPEED_DICT[obstacle_type]
	
	spawn_timer.wait_time = randf_range(spawn_time_range.x, spawn_time_range.y)
	spawn_timer.start()


func _spawn_obstacle():
	spawn_timer.wait_time = randf_range(spawn_time_range.x, spawn_time_range.y)
	var obstacle_instance: Obstacle = obstacle_scene.instantiate() as Obstacle
	obstacle_parent.add_child(obstacle_instance)
	obstacle_instance.global_position = global_position
	obstacle_instance.init(speed, is_flipped)


func _on_spawn_timer_timeout():
	_spawn_obstacle()
