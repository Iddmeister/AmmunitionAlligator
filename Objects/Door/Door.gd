extends KinematicBody2D

export var speed:float = 800
export var deceleration:float = 0.01

var knocked:bool = false
var stopped:bool = false
var velocity := Vector2(0, 0)
var spin := Vector2(0, 0)

signal smashed()

onready var pivot = $Viewport/Model/Pivot

func _ready() -> void:
	set_physics_process(false)
	pass

func _on_KnockArea_body_entered(body: Node) -> void:
	if not body.is_in_group("Alligator"):
		return
	if not knocked:
		
		
		emit_signal("smashed")
		$Debris.emitting = true
		$Break.play()
		body.camera.shake(20, 0.4, 5)
		randomize()
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, true)
		$Terrain.set_deferred("disabled", true)
		$Moving.set_deferred("disabled", false)
		$DamageArea/CollisionShape2D.set_deferred("disabled", false)
		$Normal.hide()
		$Knocked.show()
		
		var dir = -1 if to_local(body.global_position).x == abs(to_local(body.global_position).x) else 1
		
		velocity = Vector2(dir*speed, 0).rotated(global_rotation)
		spin = Vector2(-300+rand_range(-20, 20), 100+rand_range(-20, 20))
		knocked = true
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		set_physics_process(true)
		
func _physics_process(delta: float) -> void:
	if knocked and not stopped:
		velocity = velocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
		rotateDoor(spin*delta)
		var collision = move_and_collide(velocity*delta)
		if collision:
			velocity = Vector2(0, 0)
			spin = Vector2(0, 0)
			pivot.global_rotation = Vector3(0, 0, 0)
			pivot.get_child(0).global_rotation.x = 0
			pivot.get_child(0).global_rotation.y = 0
			stopped = true
			$DamageArea/CollisionShape2D.disabled = true
		
func rotateDoor(_spin:Vector2):
	_spin *= 0.1
	_spin = _spin.limit_length(1000)
	pivot.get_child(0).rotate_y(sin(OS.get_system_time_msecs()*0.01)*0.1)
	pivot.get_child(0).rotate_x(_spin.x)
	pivot.orthonormalize()


func _on_DamageArea_body_entered(body: Node) -> void:
	if stopped:
		return
	if body.is_in_group("Bullet"):
		body.queue_free()
	elif body.is_in_group("Enemy"):
		body.hit(10, global_rotation)
