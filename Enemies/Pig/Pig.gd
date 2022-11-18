extends Enemy

var seenAlligator:bool = false
var canSeeAlligator:bool = false
var canShoot:bool = false

export var Bullet:PackedScene = preload("res://Bullets/NormalBullet/NormalBullet.tscn")
export var bulletSpeed:float = 600
export var aggressive:bool = true
export var showGun:bool = true

func _ready() -> void:
	$Firerate.wait_time = 1.6+rand_range(0, 0.2)
	if not showGun:
		$Pistol.hide()
	
func ignite(dir:float=0):
	$Body.global_rotation = dir+(PI/2)
	$Body.frame = 2
	$Body.show()
	$Body/Fire.emitting = true
	$Body/Fire.global_rotation = 0
	$Pistol.hide()
	die()
	yield(get_tree().create_timer(5), "timeout")
	$Body/Fire.emitting = false
	
func shot(dir:float=0):
	.shot(dir)
	spawnBlood()
	spawnShotBlood()
	$Body.global_rotation = dir+(PI/2)
	$Body.show()
	$Pistol.hide()
	
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
	$Pistol.hide()
	
func die():
	.die()
	$Firerate.stop()
	canShoot = false
	
func think(delta:float):
	if not aggressive:
		return
	if canSeeAlligator:
		global_rotation = lerp_angle(global_rotation, (alligator.global_position-global_position).angle(), 0.5*delta*60)
		$Pistol.global_rotation = (alligator.global_position-$Pistol.global_position).angle()
	else:
		global_rotation = lerp_angle(global_rotation, velocity.angle(), 0.2*delta*60)
	
func navUpdate():
	if not aggressive:
		return
	canSeeAlligator = not castToAlligator()
	if not seenAlligator and canSeeAlligator:
		seenAlligator = canSeeAlligator
	if canSeeAlligator:
		moving = true
		navAgent.set_target_location(alligator.global_position+Vector2(140, 0).rotated((global_position-alligator.global_position).angle()+(deg2rad(45)*randOffset-0.5)*2))
		if canShoot:
			shoot()
	elif seenAlligator:
		navAgent.set_target_location(alligator.global_position)
		moving = true
		
func shoot():
	
	if dead:
		return
	
	canShoot = false
	$Firerate.start(1.6+rand_range(0, 0.2))
	
	$Pistol.global_rotation = (alligator.global_position-$Pistol.global_position).angle()
	
	var b = Bullet.instance()
	b.isEnemy = true
	get_parent().add_child(b)
	b.speed = bulletSpeed
	b.global_position = $Pistol/Muzzle.global_position
	b.global_rotation = $Pistol.global_rotation
	
	$Shoot.pitch_scale = 1+rand_range(0, 0.2)
	$Shoot.play()


func _on_Firerate_timeout() -> void:
	if not dead:
		canShoot = true
