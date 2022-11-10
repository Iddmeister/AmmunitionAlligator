extends Area2D

export var speed:float = 800

func _ready() -> void:
	$Graphics.global_rotation = rand_range(0, 2*PI)
	var t = create_tween()
	t.tween_property($Graphics, "scale", scale*6, 1)

func _physics_process(delta: float) -> void:
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)

func _on_Time_timeout() -> void:
	queue_free()


func _on_Flame_body_entered(body: Node) -> void:
	if body.is_in_group("Flammable"):
		body.ignite()
		
	if body.get_collision_layer_bit(1):
		queue_free()
	
