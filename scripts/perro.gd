extends CharacterBody2D
@onready var perro: AnimatedSprite2D = $perro
@onready var ray_cast_derecha: RayCast2D = $RayCastDerecha
@onready var ray_cast_izquierda: RayCast2D = $RayCastIzquierda

const SPEED = 60.0
var velocidad_actual = SPEED

func _ready() -> void:
	perro.play("run")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if velocidad_actual > 0 and (not ray_cast_derecha.is_colliding() or is_on_wall()):
		velocidad_actual = -SPEED
		perro.flip_h = true
	elif velocidad_actual < 0 and (not ray_cast_izquierda.is_colliding() or is_on_wall()):
		velocidad_actual = SPEED
		
		perro.flip_h = false
	velocity.x = velocidad_actual

	move_and_slide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.muerte()
		
