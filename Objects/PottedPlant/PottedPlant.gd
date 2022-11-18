tool

extends KinematicBody2D

export var frame:int = 0 setget setFrame
export var speed:float = 700
export var spinSpeed:float = 20
var spat:bool = false
var spatDir:float

var Smash = preload("res://Objects/PottedPlant/PotSmash.tscn")

var alligator

func setFrame(val):
	frame = val
	$Sprite.frame = val

func hit(_damage:int, _dir:float=0):
	destroy()
	
func swallow():
	set_collision_mask_bit(2, true)
	set_collision_layer_bit(6, false)
	get_parent().remove_child(self)

func spit(_alligator, dir:float):
	alligator = _alligator
	$Shadow.show()
	alligator.get_parent().add_child(self)
	spat = true
	spatDir = dir
	global_position = alligator.global_position

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if spat:
		$Sprite.global_rotation += delta*spinSpeed
		var collision = move_and_collide(Vector2(speed, 0).rotated(spatDir)*delta)
		if collision:
			if collision.collider.is_in_group("Hittable"):
				collision.collider.hit(3, spatDir)
				if collision.collider.is_in_group("Enemy") and alligator:
					alligator.camera.shake(20, 0.2, 5)
			if not collision.collider.is_in_group("Soft"):
				destroy()
			
func destroy():
	hide()
	var s = Smash.instance()
	get_parent().add_child(s)
	s.global_position = global_position
	$Smash.pitch_scale  =1+rand_range(-0.2, 0.2)
	$Smash.play()
	$CollisionShape2D.disabled = true



func _on_Smash_finished() -> void:
	if not Engine.is_editor_hint():
		queue_free()
