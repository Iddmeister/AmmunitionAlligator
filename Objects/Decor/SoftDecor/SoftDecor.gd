extends StaticBody2D

export var smashColour:Color
var Smash = preload("res://Objects/Decor/SoftDecor/Smash.tscn")

func hit(_damage:int, _dir:float=0):
	hide()
	var s = Smash.instance()
	s.modulate = smashColour
	get_parent().add_child(s)
	s.global_position = global_position
	queue_free()
