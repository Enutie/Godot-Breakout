extends StaticBody2D

signal destroyed(points: int)

@export var points := 10

func hit() -> void:
	destroyed.emit(points)
	queue_free()
