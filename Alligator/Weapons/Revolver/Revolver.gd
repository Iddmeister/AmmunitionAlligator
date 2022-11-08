extends Weapon

export var Bullet:PackedScene = preload("res://Bullets/NormalBullet/NormalBullet.tscn")
var MuzzleFlash = preload("res://Alligator/Weapons/Revolver/MuzzleFlash.tscn")

func attack(pos:Vector2):
	.attack(pos)
	
	if not reloading and $FireDelay.time_left == 0 and currentClip > 0:
		shoot()
	elif not reloading and not currentClip > 0:
		$Empty.play()
	
func shoot():
	
	$Shoot.pitch_scale = 1+rand_range(-0.2, 0.5)
	
	alligator.camera.shake(3, 0.2, 3)
	
	var m = MuzzleFlash.instance()
	$Muzzle.add_child(m)
	$Animation.play("Shoot")
	
	var b = Bullet.instance()
	get_tree().root.add_child(b)
	b.global_position = $Muzzle.global_position
	b.global_rotation = global_rotation
	useAmmo()
	$FireDelay.start()
	
func reload():
	if not .reload():
		return
	$Animation.queue("Reload")


func _on_FireDelay_timeout() -> void:
	pass # Replace with function body.
