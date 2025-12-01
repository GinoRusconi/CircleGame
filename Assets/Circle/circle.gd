class_name Circle extends Node2D

const HEART = preload("res://Assets/Circle/heart.tscn")
@onready var line_2d: Line2D = $Line2D

@onready var position_heart: Node = $PositionHeart
var positions_heart: Dictionary
var hearts_counts = 0
var dir : Vector2
var extremo
var handler_spawn : HandleSpawn = null
var is_active = false
var is_destroy = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func construct(_handler_spawn: HandleSpawn):
	handler_spawn = _handler_spawn

func _ready() -> void:
	var count = 0
	
	
	
	for child in position_heart.get_children():
		positions_heart[count] = [child as Marker2D, null]
		count +=1
	EventBus.on_pause.connect(paused)
	EventBus.on_game_over.connect(destroy)
	var heart_instance = HEART.instantiate() as Node2D
	add_child(heart_instance)
	hearts_counts = 1
	var random_range =  randi_range(0,8)
	heart_instance.global_position = positions_heart[random_range][0].global_position
	positions_heart[random_range][1] = heart_instance
	start_fall()

func _process(delta: float) -> void:
	if is_active:
		dir = Input.get_vector("left","right","up","down")
		if dir == Vector2.ZERO : dir = Vector2(1,0)
		extremo = dir * 112
		var tween = get_tree().create_tween()
		var point: PackedVector2Array = [Vector2.ZERO, extremo]
		tween.tween_property($Line2D, "points", point, 0.08).set_trans(Tween.TRANS_LINEAR)
		
	self.position += Vector2.DOWN * 60 * delta
	
	var h = get_viewport_rect().size.y + 100
	if global_position.y > h && !is_destroy:
		EventBus.on_game_over.emit()

func target_active():
	EventBus.on_sin_cos_press.connect(Callable(self,"check_hit_heart")) ##TODO desconectar Eventos
	is_active = true
	self.scale = Vector2(0.4,0.4)
	pass

func check_hit_heart(calleable: Callable, position):
	var extemo = dir*112
	
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
		audio_stream_player_2d.play()
		positions_heart[position][1].destroy()
		hearts_counts -= 1
	
	calleable.call(result)
	
	if hearts_counts == 0:
		destroy()
	pass

func paused(condition: bool):
	self.visible = condition
	

func start_fall():
	var fall_end_y = 50  # donde entra en la ventana
   
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "position:y", fall_end_y, 0.35) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_BACK) # un pequeño rebote suave

	tween.finished.connect(_on_fall_finished)

func _on_fall_finished():
	pass

func destroy():
	if EventBus.on_sin_cos_press.is_connected(Callable(self,"check_hit_heart")):
		EventBus.on_sin_cos_press.disconnect(Callable(self,"check_hit_heart"))
	
	is_destroy = true
	
	handler_spawn.destroy_circle(self)

	var tween = get_tree().create_tween()
	tween.tween_interval(0.3)
	tween.tween_property(self, "rotation", deg_to_rad(360), 0.3)
	await tween.tween_property(self, "scale", Vector2(0, 0), 0.3).finished

	queue_free()
