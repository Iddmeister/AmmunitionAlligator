extends Area2D

export var speed:float = 800

func _ready() -> void:
	$Graphics.global_rotation = rand_range(0, 2*PI)
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property($Graphics, "scale", Vector2(3, 3), 0.5)
	t.tween_property($CollisionShape2D.shape, "radius", 45.0, 0.5)

func _physics_process(delta: float) -> void:
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)

func _on_Time_timeout() -> void:
	queue_free()


func _on_Flame_body_entered(body: Node) -> void:
	if body.is_in_group("Flammable"):
		if body.is_in_group("Enemy"):
			body.ignite(global_rotation)
		else:
			body.ignite()
		
	if body.get_collision_layer_bit(1):
		queue_free()
	
