extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $cuerpoPrincipal/AnimatedSprite2D
@onready var pivote: Node2D = $pivote

@export var velocidad_rotacion: float = 2.0 

func _ready() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")

func _process(delta: float) -> void:

	pivote.rotation += velocidad_rotacion * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("muerte"):
		body.muerte()


func _matar_boss_body_entered(body: Node2D) -> void:
	if body.name == "player":
		queue_free()
