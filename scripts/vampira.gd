extends CharacterBody2D

# Referencia al sprite renombrado
@onready var sprite: AnimatedSprite2D = $SpriteVampira

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var estaMuerta = false

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Bloqueo si está muerta
	if estaMuerta:
		velocity.x = 0
		move_and_slide()
		return

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var multiplier = 1.5 if Input.is_action_pressed("run") else 1.0

	# Movimiento horizontal
	if Input.is_action_pressed("left"):
		sprite.flip_h = true
		velocity.x = -SPEED * multiplier
	elif Input.is_action_pressed("right"):
		sprite.flip_h = false
		velocity.x = SPEED * multiplier
	else:
		velocity.x = 0

	move_and_slide()

func _process(_delta: float) -> void:
	if estaMuerta:
		return

	# Gestión de animaciones
	if is_on_floor():
		if velocity.x == 0:
			sprite.play("idle")
		elif Input.is_action_pressed("run"):
			sprite.play("run")
		else:
			sprite.play("walk")
	else:
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")

func muerte() -> void:
	if not estaMuerta:
		estaMuerta = true
		sprite.play("die")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.is_in_group("enemigos"):
		muerte()
