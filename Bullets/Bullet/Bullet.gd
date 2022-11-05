extends Area2D

class_name Bullet

export var speed:float = 800
export var damage:int = 1
var shooter

func _physics_process(delta: float) -> void:
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)


func _on_Time_timeout() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	
	if body == shooter:
		return
	
	if body.is_in_group("Hittable"):
		body.hit(damage)
	
	queue_free()
