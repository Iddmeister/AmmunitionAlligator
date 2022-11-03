extends KinematicBody2D

var velocity:Vector2
export var deceleration:float = 0.05

onready var sphere = $Viewport/Head/Sphere

func movement(delta:float):
	
	velocity = velocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		
	rotateHead(velocity*delta)
		
func rotateHead(vel:Vector2):
	vel *= 0.1
	sphere.rotate_x(vel.y)
	sphere.rotate_y(vel.x)
	sphere.orthonormalize()

func _physics_process(delta: float) -> void:
	movement(delta)
