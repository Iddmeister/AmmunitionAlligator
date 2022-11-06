extends Node

export var cursorOpen:Texture
export var cursorClosed:Texture
var cursorIsOpen:bool = true

func _on_CursorBite_timeout() -> void:
	Input.set_custom_mouse_cursor(cursorOpen if cursorIsOpen else cursorClosed)
	ProjectSettings.set_setting("display/mouse_cursor/custom_image_hotspot", Vector2(16, 16))
	cursorIsOpen = not cursorIsOpen
