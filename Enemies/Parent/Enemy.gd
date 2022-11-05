extends KinematicBody2D

class_name Enemy

var Blood = preload("res://Blood/Blood.tscn")
var Head = preload("res://Misc/SeveredHead/Head.tscn")

export var health:int = 3

func hit(damage:int=1):
	
	health -= damage
	
	if not health <= 0:
		return
	
	hide()
	
	spawnBlood()
	$Squelch.pitch_scale = 1+rand_range(-0.5, 0.5)
	$Squelch.play()
	$CollisionShape2D.set_deferred("disabled", true)
	call_deferred("spawnHead")
	yield($Squelch, "finished")
	queue_free()
	
func spawnBlood():
	
	for n in range(5):
		var b = Blood.instance()
		get_parent().add_child(b)
		b.global_position = global_position+(Vector2(10, 0).rotated(2*PI*(float(n)/5)))

func spawnHead():
	var h = Head.instance()
	h.velocity = Vector2(300, 0).rotated(rand_range(0, 2*PI))
	get_parent().add_child(h)
	h.global_position = global_position
