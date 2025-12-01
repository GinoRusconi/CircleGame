extends Node2D

@onready var destroy_particle: GPUParticles2D = $Destroy
@onready var sprite_2d: Sprite2D = $Sprite2D

func destroy():
	destroy_particle.emitting = true
	sprite_2d.texture = null
	
