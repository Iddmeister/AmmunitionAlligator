extends KinematicBody2D

class_name Enemy

var Blood = preload("res://Blood/Blood.tscn")

func hit():
	
	hide()
	get_parent()
	spawnBlood()
	$Squelch.pitch_scale = 1+rand_range(-0.5, 0.5)
	$Squelch.play()
	$CollisionShape2D.set_deferred("disabled", true)
	yield($Squelch, "finished")
	queue_free()
	
func spawnBlood():
	
	for n in range(5):
		var b = Blood.instance()
		get_parent().add_child(b)
		b.global_position = global_position+(Vector2(10, 0).rotated(2*PI*(float(n)/5)))
