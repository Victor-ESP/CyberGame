extends Area2D

func _physics_process(delta: float) -> void:
	position.x += 1
	$sangre.flip_h = true
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("muerte"):
		body.muerte()
