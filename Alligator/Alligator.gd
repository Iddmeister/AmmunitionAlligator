extends KinematicBody2D

class_name Alligator

export var moveSpeed:float = 300
export var acceleration:float = 0.5

var velocity:Vector2

onready var legs = $Graphics/Legs
onready var weaponPivot = $Weapon/Pivot
onready var weapon = $Weapon/Pivot.get_child(0)

var Head = preload("res://Misc/SeveredHead/Head.tscn")

func getMoveDir() -> Vector2:
	
	var dir:Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	
	return dir.normalized()
	
func movement(delta:float):
	
	velocity = move_and_slide(velocity.linear_interpolate(getMoveDir()*moveSpeed, acceleration*delta*60))
	
	global_rotation = lerp_angle(global_rotation, (get_global_mouse_position()-global_position).angle(), 0.5*delta*60)
	
	if velocity.length() > 0 and not legs.playing:
		legs.play("walk")
	elif velocity.length() <= 3:
		legs.stop()
		
	legs.global_rotation = velocity.angle()+(PI/2)
	
func actions(delta:float):
	
	weaponPivot.global_rotation = lerp_angle(weaponPivot.global_rotation, (get_global_mouse_position()-weaponPivot.global_position).angle(), 0.5*delta*60)
	
	if Input.is_action_just_pressed("reload"):
		weapon.reload()
	
	if Input.is_action_just_pressed("bite"):
		$Bite.pitch_scale = 0.8+rand_range(-0.2, 0)
		$Bite.play()
		$Graphics/Torso/Head/Animation.play("Bite")
		
	if Input.is_action_just_pressed("attack"):
		weapon.attack(get_global_mouse_position())
		
func bite():
	for body in $BiteArea.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.hit(10)

func _physics_process(delta: float) -> void:
	movement(delta)
	actions(delta)
	$Lighter/AnimatedSprite.global_rotation = 0
