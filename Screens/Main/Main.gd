extends Control

func _ready() -> void:
	Music.playTrack("ambience")

func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Play_pressed() -> void:
	Manager.changeScene("res://Levels/Level3/Level3.tscn")




func _on_Options_pressed() -> void:
	$Menu.hide()
	$Options.show()



func _on_Options_done() -> void:
	$Menu.show()
