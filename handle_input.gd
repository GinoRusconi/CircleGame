class_name HandleInput extends Control

@onready var menu: Control = $Menu
@onready var hud: Control = $HUD
@onready var score_label: Label = $HUD/Score
@onready var sin_cos_label: Label = $HUD/SinCos
@onready var main_scene: Node2D = $".."
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const CIRCLE = preload("uid://snq0geweycfg")
const TUTORIAL = preload("uid://dv18twys0ukvv")
var tutorial_instance

var score : int = 0
var is_pause : bool = false
var is_playing: bool = false
var is_tutorial : bool = false

var results: Array = []
var dir:Vector2
var handleSpawn : HandleSpawn 

func _ready() -> void:
	handleSpawn = %HandlerSpawn

func _process(delta: float) -> void:
	dir = Input.get_vector("left","right","down","up")
	if dir == Vector2.ZERO : dir = Vector2(1,0)
	
	if Input.is_action_just_pressed("sin"):sin_button()
	if Input.is_action_just_pressed("cos"):cos_button()
	
	#if Input.is_action_just_pressed("menu") && !is_pause && is_playing: open_menu()
	#elif Input.is_action_just_pressed("menu") && is_pause: close_menu()


func cos_button()-> void:
	results.clear()
	var vector_result = round(cos(dir.angle()) * 10) / 10.0
	match vector_result:
		1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 0)
		0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 1)
		-0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 2)
		-1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 3)
		0.0:EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 4)
	sin_cos_label.text = "COS"
	print(results)
	pass

func sin_button():
	results.clear()
	var vector_result = round(sin(dir.angle()) * 10) / 10.0
	match vector_result:
		1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 5)
		0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 6)
		-0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 7)
		-1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 8)
		0.0:EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 4)
	print(results)
	sin_cos_label.text = "SIN"
	pass

func hit_check(success: bool):
	results.append(success)
	if results[0] == false:
		main_scene.start_shake()
		audio_stream_player_2d.play()
		EventBus.on_game_over.emit()
		is_playing = false
		menu.visible = true
		return
	if results[0] == true:
		score += 1
		score_label.text = str(score)

func close_menu():
	is_pause = false

	menu.visible = false
	EventBus.on_pause.emit(true)
	get_tree().paused = false

func open_menu():
	is_pause = true

	menu.visible = true
	get_tree().paused = true
	EventBus.on_pause.emit(false)

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	handleSpawn.start_spawn()
	is_playing = true
	score = 0
	menu.visible = false
	EventBus.on_pause.emit(true)
	get_tree().paused = false
	if is_tutorial:
		_on_tutorial_pressed()
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	if not is_tutorial:
		tutorial_instance = TUTORIAL.instantiate()
		add_child(tutorial_instance)
		is_tutorial = true
	else:
		tutorial_instance.queue_free()
		is_tutorial = false
