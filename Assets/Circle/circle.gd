class_name Cirle extends Node2D

const HEART = preload("res://Assets/Circle/heart.tscn")

@onready var position_heart: Node = $PositionHeart
var positions_heart: Dictionary


func _ready() -> void:
	var count = 0
	
	for child in position_heart.get_children():
		positions_heart[count] = [child as Marker2D, null]
		count +=1
	construct()
	
	
	var heart_instance = HEART.instantiate() as Node2D
	add_child(heart_instance)
	heart_instance.global_position = positions_heart[randi_range(0,8)][0].global_position


func construct() -> void:
	pass
