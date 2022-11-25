extends Area2D

var Flamethrower = preload("res://Objects/Ethanol/Flamethrower.tscn")
export var time:float = -1
	
signal destroyed()
	
func swallow():
	emit_signal("destroyed")
	$Break.play()
	$Glass.emitting = true
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$FreeTime.start($Glass.lifetime/$Glass.speed_scale)
	
func spit(alligator, _dir:float):
	var f = Flamethrower.instance()
	f.get_node("Time").wait_time = time if time > 0 else f.get_node("Time").wait_time
	alligator.get_node("Flames").add_child(f)
	queue_free()


func _on_FreeTime_timeout() -> void:
	get_parent().remove_child(self)
