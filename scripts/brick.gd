extends StaticBody2D

func _ready() -> void:
	var area = get_node("%Area2D")
	

func _on_body_entered():
	queue_free()
