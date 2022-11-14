extends KinematicBody2D

var velocity:Vector2

export var blood:bool = true
export var explode:bool = true

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
var exploded:bool = false

func _ready() -> void:
	if blood:
		$Blood.emitting = true

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
		
	if blood:
			
		if velocity.length() <= 10 and not still:
			still = true
			spawnBlood()
			$Blood.emitting = false
		elif velocity.length() > 10:
			still = false
			$Blood.emitting = true
		
var Blood = preload("res://Blood/Blood.tscn")
		
func spawnBlood():
	var b = Blood.instance()
	b.slow = true
	get_parent().add_child(b)
	b.global_position = global_position+Vector2(rand_range(0, 15), 0).rotated(rand_range(0, 2*PI))


func rotateHead(vel:Vector2):
	vel *= 0.1
	vel = vel.limit_length(1000)
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
	if not exploded:
		movement(delta)
	
func spit(alligator, dir:float=0):
	velocity = Vector2(685+rand_range(-40, 40), 0).rotated(dir)
	alligator.get_parent().add_child(self)
	sphere.rotate_x(rand_range(0, 1))
	sphere.rotate_y(rand_range(0, 1))
	global_position = alligator.global_position
	
func hit(_damage:int, dir:float=0):
	if explode:
		exploded = true
		$Sprite.hide()
		$Blood.emitting = false
		$Explode.emitting  = true
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		velocity += Vector2(300, 0).rotated(dir)
