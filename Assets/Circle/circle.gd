class_name Cirle extends Node2D

const HEART = preload("res://Assets/Circle/heart.tscn")
@onready var line_2d: Line2D = $Line2D

@onready var position_heart: Node = $PositionHeart
var positions_heart: Dictionary
var dir : Vector2
var extremo

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
	EventBus.on_sin_cos_press.connect(Callable(self,"check_hit_heart")) ##TODO desconectar Eventos

func _process(delta: float) -> void:
	dir = Input.get_vector("left","right","up","down")
	if dir == Vector2.ZERO : dir = Vector2(1,0)
	extremo = dir * 128
	var tween = get_tree().create_tween()
	var point: PackedVector2Array = [Vector2.ZERO, extremo]
	tween.tween_property($Line2D, "points", point, 0.08).set_trans(Tween.TRANS_LINEAR)
	

func check_hit_heart(calleable: Callable, position):
	var extemo = dir*128
	
	$Line2D2.clear_points()
	var tween = get_tree().create_tween()
	var point: PackedVector2Array = [extemo, positions_heart[position][0].position]
	$Line2D2.points = [extemo,extemo]
	tween.tween_property($Line2D2, "points", point, 0.08).set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_interval(0.1)
	
	var point_revers: PackedVector2Array = [positions_heart[position][0].position,positions_heart[position][0].position]
	tween.tween_property($Line2D2, "points", point_revers, 0.08).set_trans(Tween.TRANS_LINEAR)
	
	var result = false
	if positions_heart[position][1] != null:
		result = true
		positions_heart[position][1].queue_free()
	 
	calleable.call(result)
	
	pass
