extends Polygon2D

func _ready() -> void:
	$StaticBody2D/CollisionPolygon2D.polygon = polygon
