extends Node

export var cursorOpen:Texture
export var cursorClosed:Texture
var cursorIsOpen:bool = true

onready var animation: AnimationPlayer = $Layer/Animation


func _on_CursorBite_timeout() -> void:
	Input.set_custom_mouse_cursor(cursorOpen if cursorIsOpen else cursorClosed, Input.CURSOR_ARROW, Vector2(16, 16))
	cursorIsOpen = not cursorIsOpen
