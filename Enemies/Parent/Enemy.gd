extends KinematicBody2D

class_name Enemy

var Blood = preload("res://Blood/Blood.tscn")
export var Head:PackedScene
var EatParticles = preload("res://Enemies/Parent/EatParticles.tscn")

export var health:int = 3
export var moveSpeed:float = 100
var dead:bool = false
onready var navAgent: NavigationAgent2D = $NavAgent
var velocity:Vector2
var moving:bool = false
var alligator:Node2D

signal died()

func _ready() -> void:
	navAgent.connect("velocity_computed", self, "move")

func think(_delta:float):
	pass

func _physics_process(delta: float) -> void:
	
	if dead:
		return
		
	think(delta)
		
	if not navAgent.is_navigation_finished() and moving:
		if not $Graphics/Legs.playing:
			$Graphics/Legs.play("walk")
		var pos = navAgent.get_next_location()
		velocity = (pos-global_position).normalized()*moveSpeed
		navAgent.set_velocity(velocity)
	else:
		moving = false
		$Graphics/Legs.stop()
	
func move(_velocity:Vector2):
	velocity = move_and_slide(_velocity)
	$Graphics/Legs.global_rotation = lerp_angle($Graphics/Legs.global_rotation, velocity.angle()+(PI/2), 0.5*get_physics_process_delta_time()*60)

func hit(damage:int=1, dir:float=0):
	
	if dead:
		return
	
	health -= damage
	
	$Graphics/Animation.play("Hit")
	
	if not health <= 0:
		return
	
	shot(dir)
	
func shot(_dir:float=0):
	die()
	
func ignite(_dir:float=0):
	die()
	
func bite(_alligator):
	if dead:
		return
	health = 0
	eaten(_alligator)
	
func eaten(_alligator):
	die()
	
func die():
	if dead:
		return
		
	$Graphics.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$NavUpdate.stop()
	navAgent.disconnect("velocity_computed", self, "move")
	navAgent.queue_free()
	z_index = -4
	dead = true
	emit_signal("died")
	
func spawnBlood(pos:Vector2=global_position, amount:int=5, offset:float=17, random:bool=false):
	for n in range(amount):
		var b = Blood.instance()
		get_parent().add_child(b)
		b.global_position = pos+(Vector2(offset, 0).rotated(rand_range(0, 2*PI) if random else 2*PI*(float(n)/5)))
		
func spawnShotBlood():
	var t = Blood.instance()
	get_parent().add_child(t)
	t.global_position = global_position
	t.z_as_relative = true
	t.z_index = -2
	t.scale = Vector2(0.5, 0.5)

func spawnHead():
	var h = Head.instance()
	h.velocity = Vector2(300, 0).rotated(rand_range(0, 2*PI))
	get_parent().add_child(h)
	h.global_position = global_position
	
func spawnEatParticles(pos:Vector2=global_position, rot:float=global_rotation):
	var e = EatParticles.instance()
	add_child(e)
	e.global_position = pos
	e.global_rotation = rot


func _on_NavUpdate_timeout() -> void:
	navUpdate()
		
func navUpdate():
	pass
	
func castToAlligator():
	if not alligator:
		return true
	if get_world_2d().direct_space_state.intersect_ray(global_position, alligator.global_position, [self], 0b10):
		return true
	else:
		return false
