class_name HandleInput extends Control

var dir:Vector2
var results: Array = []

func _process(delta: float) -> void:
	dir = Input.get_vector("left","right","down","up")
	if dir == Vector2.ZERO : dir = Vector2(1,0)
	
	if Input.is_action_just_pressed("sin"):sin_button()
	if Input.is_action_just_pressed("cos"):cos_button()


func cos_button()-> void:
	results.clear()
	var vector_result = round(cos(dir.angle()) * 10) / 10.0
	match vector_result:
		1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 0)
		0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 1)
		-0.7: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 2)
		-1.0: EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 3)
		0.0:EventBus.on_sin_cos_press.emit(Callable(self, "hit_check"), 4)
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
	pass

func hit_check(success: bool):
	results.append(success)
	
	pass
