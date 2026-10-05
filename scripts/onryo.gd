extends Node2D

@onready var sprite: AnimatedSprite2D = $enemigoNuevo/onryo
var sangre = preload("res://escenas/sangre.tscn")
func _ready() -> void:
	if sprite:
		sprite.play("idle")

func _on_timer_timeout() -> void:
	if sangre:
		var nuevaBala = sangre.instantiate()
		get_parent().add_child(nuevaBala)
		nuevaBala.global_position = global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Has entrado en area lanzar")
	if  body.has_method("muerte") or body.name == "player":
		if sprite:
			sprite.play("lanzar")
