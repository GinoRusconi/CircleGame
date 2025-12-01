class_name HandleSpawn
extends Node2D

const CIRCLE = preload("uid://snq0geweycfg")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var position_spawn : Array[Marker2D]
var circle_queue: Array[Circle] = []
var active_circle: Circle = null
@onready var timer: Timer = $Timer
var game_over:bool =false
var level = 0
var current_round = 0
var levels = [
			[1,2],
			[2,3],
			[3,8],
			[4,10],
			[5,15],
			[6,20],
			[7,30],
]


func _ready() -> void:
	EventBus.on_game_over.connect(stop_spawn)

func start_spawn():
	circle_queue.clear()
	game_over = false
	timer.start()
	pass

func stop_spawn():
	circle_queue.clear()
	game_over = true
	level = 0
	current_round = 0
	timer.stop()
	pass

func register_circle(circle: Circle) -> void:
	circle_queue.append(circle)

	# Si no hay uno activo aún → activar el primero
	if active_circle == null:
		_activate_next_circle()


func destroy_circle(circle: Circle):
	if !game_over:
		circle_queue.erase(circle)

		# si destruyeron el que estaba activo limpiamos
		if circle == active_circle:
			active_circle = null
			_activate_next_circle()


func _activate_next_circle():
	if circle_queue.is_empty():
		return

	active_circle = circle_queue[0]

	# conectar evento SOLO a este círculo
	#EventBus.on_sin_cos_press.connect(active_circle.check_hit_heart)

	active_circle.target_active()
	print("Activado círculo:", active_circle)


func _on_timer_timeout() -> void:
	var numeros = range(0, position_spawn.size())
	numeros.shuffle()

	var resultados = numeros.slice(0, levels[level][0])
	resultados.sort()
	
	if current_round > levels[level][1] && level < 7: 
		level += 1
		current_round = 0
	
	current_round += 1
	
	for r in resultados:
		var circle_instance = CIRCLE.instantiate()
		add_child(circle_instance)

		circle_instance.global_position = position_spawn[r].global_position
		circle_instance.construct(self)

		register_circle(circle_instance)
	audio_stream_player_2d.play()
