extends StaticBody2D

var bala = preload("res://escenas/balaArriba.tscn")
	
func _on_timer_timeout() -> void:
	var nuevaBala = bala.instantiate()
	add_child(nuevaBala)
	nuevaBala.position = $Player.position
