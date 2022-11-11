extends Area2D

var Flamethrower = preload("res://Objects/Ethanol/Flamethrower.tscn")

	
func swallow():
	$Break.play()
	$Glass.emitting = true
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$FreeTime.start($Glass.lifetime/$Glass.speed_scale)
	
func spit(alligator, _dir:float):
	var f = Flamethrower.instance()
	alligator.get_node("Flames").add_child(f)
	queue_free()


func _on_FreeTime_timeout() -> void:
	get_parent().remove_child(self)
