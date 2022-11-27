extends Control



func _on_LinkButton_pressed() -> void:
	OS.shell_open("https://onemansymphony.bandcamp.com")


func _on_Menu_pressed() -> void:
	Manager.changeScene("res://Screens/Main/Main.tscn")
