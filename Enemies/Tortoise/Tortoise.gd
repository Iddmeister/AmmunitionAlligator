extends Enemy

var Sparks = preload("res://Enemies/Tortoise/Sparks.tscn")

func hit(damage:int=1, dir:float=0):
	var s = Sparks.instance()
	get_parent().add_child(s)
	s.global_position = global_position+(Vector2($CollisionShape2D.shape.radius, 0).rotated(PI+dir))
	s.global_rotation = PI+dir
	$Ricochet.pitch_scale = 1+rand_range(-0.2, 0.2)
	$Ricochet.play()
	
func eaten(_alligator):
	.eaten(_alligator)
#	$Body.frame = 1
#	$Body.global_rotation = (global_position-alligator.global_position).angle()+(PI/2)
#	$Body.show()
#	spawnBlood($Body.to_global(Vector2(0, -17)))
#	spawnEatParticles($Body.to_global(Vector2(0, -10)), $Body.global_rotation)
	_alligator.swallow(Head.instance())
	$Squelch.play()
#	$Pistol.hide()
