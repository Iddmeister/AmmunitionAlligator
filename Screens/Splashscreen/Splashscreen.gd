extends Control

func _on_Time_timeout() -> void:
	Manager.connect("changedScene", self, "free")
	Manager.changeScene("res://Levels/Level1/Level1.tscn")
