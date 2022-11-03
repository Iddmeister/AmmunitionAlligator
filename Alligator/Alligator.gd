extends KinematicBody2D

class_name Alligator

export var moveSpeed:float = 300
export var acceleration:float = 0.5

var velocity:Vector2

onready var legs = $Graphics/Legs

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
	
var start:Vector2
var aiming:bool = false
	
func actions():
	if Input.is_action_just_pressed("bite"):
		$Bite.pitch_scale = 0.8+rand_range(-0.2, 0)
		$Bite.play()
		$Graphics/Torso/Head/Animation.play("Bite")
	if Input.is_action_pressed("attack"):
		if aiming:
			return
		start = get_global_mouse_position()
		aiming = true
	elif Input.is_action_just_released("attack"):
		aiming = false
		var h = Head.instance()
		get_parent().add_child(h)
		h.global_position = start
		h.velocity = (get_global_mouse_position()-start).normalized()*500

func bite():
	for body in $BiteArea.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.hit()

func _physics_process(delta: float) -> void:
	movement(delta)
	actions()
