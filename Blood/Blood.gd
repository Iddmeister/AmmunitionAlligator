extends Node2D

var slow:bool = false

func _ready() -> void:
	$Sprite.frame = floor(rand_range(0, 3.9))
	$Sprite.global_rotation = rand_range(0, 2*PI)
	$Sprite.modulate = $Sprite.modulate.darkened(rand_range(0, 0.5))
	if slow:
		$Animation.play("SlowPool")
	else:
		$Animation.play("Pool")
