extends Control

func _on_Time_timeout() -> void:
	Manager.connect("changedScene", self, "free")
	Manager.changeScene("res://Screens/Main/Main.tscn")
