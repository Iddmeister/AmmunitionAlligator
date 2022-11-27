extends Control

func _ready() -> void:
	Music.playTrack("neverknow")
	
	for button in $LevelSelect/CenterContainer/VBoxContainer/HBoxContainer.get_children():
		button.connect("pressed", self, "goToLevel", [button.name])

func goToLevel(level:String):
	Manager.changeScene("res://Levels/Level%s/Level%s.tscn" % [level, level])

func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Play_pressed() -> void:
	$LevelSelect.show()
	$Menu.hide()


func _on_Options_pressed() -> void:
	$Menu.hide()
	$Options.show()


func _on_Options_done() -> void:
	$Menu.show()


func _on_Back_pressed() -> void:
	$LevelSelect.hide()
	$Menu.show()
