extends Area2D

export var ammo:int = 6

func _on_Ammo_body_entered(body: Node) -> void:
	body.weapon.addAmmo(ammo)
	queue_free()
