extends Area2D

class_name Bullet

export var playerSpeed:float = 800
onready var speed = playerSpeed
export var damage:int = 1
var isEnemy:bool = false

func _ready() -> void:
	if isEnemy:
		add_to_group("Swallowable")

func _physics_process(delta: float) -> void:
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)


func _on_Time_timeout() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	
	if isEnemy and body.is_in_group("Enemy"):
		return
	elif not isEnemy and body.is_in_group("Alligator"):
		return
	
	if body.is_in_group("Hittable"):
		body.hit(damage, global_rotation)
	
	if not body.is_in_group("Soft"):
		queue_free()
		
func swallow():
	get_parent().remove_child(self)
	
func spit(alligator, dir:float):
	isEnemy = false
	remove_from_group("Swallowable")
	speed = playerSpeed
	damage *= 2
	alligator.get_parent().add_child(self)
	global_position = alligator.global_position
	global_rotation = dir
