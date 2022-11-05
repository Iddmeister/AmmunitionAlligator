extends Weapon

export var Bullet:PackedScene = preload("res://Bullets/NormalBullet/NormalBullet.tscn")
var MuzzleFlash = preload("res://Alligator/Weapons/Revolver/MuzzleFlash.tscn")

func attack(pos:Vector2):
	.attack(pos)
	var m = MuzzleFlash.instance()
	$Muzzle.add_child(m)
	$Animation.play("Shoot")
	
	var b = Bullet.instance()
	get_tree().root.add_child(b)
	b.global_position = $Muzzle.global_position
	b.global_rotation = global_rotation
	
func reload():
	$Animation.play("Reload")
	pass
