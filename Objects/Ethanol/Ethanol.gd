extends Area2D

var Flamethrower = preload("res://Objects/Ethanol/Flamethrower.tscn")

func swallow():
	get_parent().remove_child(self)
	
func spit(alligator, dir:float):
	var f = Flamethrower.instance()
	alligator.add_child(f)
	
