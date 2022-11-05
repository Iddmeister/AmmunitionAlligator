extends KinematicBody2D

var velocity:Vector2
export var deceleration:float = 0.043
export var collisionDamp:float = 0.8
export var spin:bool = true
export var bounce:bool = true
export var bounceHeight:float = 0.3
onready var timeToZero = 0.8
onready var totalBounces = floor((timeToZero*10)/(PI/2))
onready var timeOneBounce = timeToZero/totalBounces

onready var sphere = $Viewport/Head/Sphere

onready var startScale = $Sprite.scale

var still:bool = false

func movement(delta:float):
	
	velocity = velocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
	var collision = move_and_collide(velocity*delta)
	if collision:
		if collision.collider.is_in_group("Loose"):
			if collision.collider.has_method("bump"):
				collision.collider.bump(velocity*collisionDamp)
		velocity = velocity.bounce(collision.normal)*collisionDamp
		
	if spin:
		rotateHead(velocity*delta)
	if bounce and timeToZero > 0:
		bounceHead(delta)
		
	if velocity.length() <= 10 and not still:
		still = true
		spawnBlood()
		$Blood.emitting = false
	elif velocity.length() > 10:
		still = false
		$Blood.emitting = true
		
var Blood = preload("res://Blood/Blood.tscn")
		
func spawnBlood():
	
	for n in range(1):
		var b = Blood.instance()
		get_parent().add_child(b)
		b.global_position = global_position+(Vector2(10, 0).rotated(2*PI*(float(n)/5)))


func rotateHead(vel:Vector2):
	vel *= 0.1
	vel = vel.clamped(1000)
	sphere.rotate_x(vel.y)
	sphere.rotate_y(vel.x)
	sphere.orthonormalize()
	
func bounceHead(delta:float):
	timeToZero -= delta
	var bGraph = abs(sin(timeToZero*10))
	$Sprite.scale = startScale+Vector2(1, 1)*bounceHeight*bGraph*((ceil(timeToZero/timeOneBounce)/totalBounces))
	
func bump(vel:Vector2):
	velocity += vel*0.5
	
func _physics_process(delta: float) -> void:
	movement(delta)
	
func spit(alligator):
	velocity = Vector2(800, 0).rotated(alligator.global_rotation)
	alligator.get_parent().add_child(self)
	global_position = alligator.global_position
