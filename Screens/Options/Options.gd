extends PanelContainer

signal done()

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("escape"):
		hide()
		emit_signal("done")

func _on_MasterSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value == -20)

func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value == -20)


func _on_Done_pressed() -> void:
	hide()
	emit_signal("done")
