extends Line2D

var time := 0.0

@export var amplitude := 50.0
@export var wavelength := 200.0
@export var resolution := 100  

func _ready():
	generate_sine_curve()


func generate_sine_curve():
	var new_points: Array[Vector2] = []

	for i in range(resolution):
		var t = float(i) / float(resolution)          
		var x = t * wavelength                         
		var y = sin(t * TAU) * amplitude               

		new_points.append(Vector2(x, y))
	
	points = new_points   


func _process(delta):
	time += delta
	var new_points: Array[Vector2] = []

	for i in range(resolution):
		var t = float(i) / float(resolution)
		var x = t * wavelength
		var y = sin(t * TAU + time) * amplitude

		new_points.append(Vector2(x, y))

	points = new_points
