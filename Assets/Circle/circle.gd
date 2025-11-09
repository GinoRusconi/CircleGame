class_name Cirle extends Node2D

const HEART = preload("res://Assets/Circle/heart.tscn")

@onready var position_heart: Node = $PositionHeart
var positions_heart: Dictionary


func _ready() -> void:
	var count = 0

	for child in position_heart.get_children():
		positions_heart[count] = [child as Marker2D, null]
		count +=1
	
	var heart_instance = HEART.instantiate() as Node2D
	add_child(heart_instance)
	var random_range =  randi_range(0,8)
	heart_instance.global_position = positions_heart[random_range][0].global_position
	positions_heart[random_range][1] = heart_instance
	EventBus.on_sin_cos_press.connect(Callable(self,"check_hit_heart"))

func check_hit_heart(calleable: Callable, position):
	var result = false
	
	if positions_heart[position][1] != null:
		result = true
		positions_heart[position][1].queue_free()
		
		
	 
	calleable.call(result)
	
	pass
