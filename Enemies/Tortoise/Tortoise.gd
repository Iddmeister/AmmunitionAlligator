extends Enemy

var Sparks = preload("res://Enemies/Tortoise/Sparks.tscn")

var seenAlligator:bool = false
var canSeeAlligator:bool = false
export var swingDistance:float = 50

func hit(damage:int=1, dir:float=0):
	var s = Sparks.instance()
	get_parent().add_child(s)
	s.global_position = global_position+(Vector2($CollisionShape2D.shape.radius, 0).rotated(PI+dir))
	s.global_rotation = PI+dir
	$Ricochet.pitch_scale = 1.5+rand_range(-0.2, 0.2)
	$Ricochet.play()
	
func eaten(_alligator):
	.eaten(_alligator)
	$Graphics/Bat.hide()
	spawnBlood(global_position, 3, 20, true)
#	spawnEatParticles($Body.to_global(Vector2(0, -10)), $Body.global_rotation)
	_alligator.swallow(Head.instance())
	$Squelch.play()
	_alligator.camera.shake(20, 0.2, 5)
	$Graphics/Bat/Animation.stop(true)
	$Debris.emitting = true
	$Debris2.emitting = true
	$Debris3.emitting = true

func doDamage():
	for body in $Damage.get_overlapping_bodies():
		if body.is_in_group("Alligator"):
			body.hit(1, (body.global_position-global_position).angle())
			
func think(delta:float):
	if canSeeAlligator:
		global_rotation = lerp_angle(global_rotation, (alligator.global_position-global_position).angle(), 0.5*delta*60)
		if not $Graphics/Bat/Animation.is_playing() and global_position.distance_to(alligator.global_position) <= swingDistance:
			$Graphics/Bat/Animation.play("Swing")
	else:
		global_rotation = lerp_angle(global_rotation, velocity.angle(), 0.2*delta*60)
	
func navUpdate():
	canSeeAlligator = not castToAlligator()
	if not seenAlligator and canSeeAlligator:
		seenAlligator = canSeeAlligator
	if canSeeAlligator:
		moving = true
		navAgent.set_target_location(alligator.global_position+Vector2(swingDistance-10, 0).rotated((global_position-alligator.global_position).angle()))#+rand_range(-PI, PI)))
	elif seenAlligator:
		navAgent.set_target_location(alligator.global_position)
		moving = true

