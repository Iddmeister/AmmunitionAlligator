extends Node

export var cursorOpen:Texture
export var cursorClosed:Texture
var cursorIsOpen:bool = true

func _on_CursorBite_timeout() -> void:
	Input.set_custom_mouse_cursor(cursorOpen if cursorIsOpen else cursorClosed)
	cursorIsOpen = not cursorIsOpen
