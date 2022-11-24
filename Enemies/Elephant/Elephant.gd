extends Enemy

func ignite(dir:float=0):
	$Body.global_rotation = dir+(PI/2)
	$Body.frame = 2
	$Body.show()
	$Body/Fire.emitting = true
	$Body/Fire.global_rotation = 0
	die()
	yield(get_tree().create_timer(5), "timeout")
	$Body/Fire.emitting = false
	
func shot(dir:float=0):
	.shot(dir)
	spawnBlood()
	spawnShotBlood()
	$Body.global_rotation = dir+(PI/2)
	$Body.show()
	
func eaten(_alligator):
	.eaten(_alligator)
	$Body.frame = 1
	$Body.global_rotation = (global_position-_alligator.global_position).angle()+(PI/2)
	$Body.show()
	spawnBlood($Body.to_global(Vector2(0, -17)), 5, 10)
	spawnEatParticles($Body.to_global(Vector2(0, -10)), $Body.global_rotation)
	_alligator.swallow(Head.instance())
	$Squelch.play()
	_alligator.camera.shake(20, 0.2, 5)
