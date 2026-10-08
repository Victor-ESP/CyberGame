extends Node

const PUERTO = 8910
const IP_SERVIDOR = "127.0.0.1"

const ESCENA_VAMPIRA = preload("res://escenas/player.tscn")
const ESCENA_LILI = preload("res://escenas/lili.tscn")

@onready var boton_servidor = $BotonServidor
@onready var boton_cliente = $BotonCliente

func _ready():
	# Señales del sistema multijugador
	multiplayer.peer_connected.connect(_al_conectarse_jugador)
	multiplayer.peer_disconnected.connect(_al_desconectarse_jugador)
	multiplayer.connected_to_server.connect(_al_conectar_exitoso_cliente)
	multiplayer.connection_failed.connect(_al_fallar_conexion)

func _on_boton_servidor_pressed():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PUERTO, 4)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		ocultar_menu()
		print("Servidor iniciado. Creando Vampira (Host ID 1)...")
		_crear_jugador(1)
	else:
		print("Error al crear servidor: ", err)

func _on_boton_cliente_pressed():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(IP_SERVIDOR, PUERTO)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("Conectando con el servidor...")
		# NO ocultamos el menú aquí; esperamos a que 'connected_to_server' responda
	else:
		print("Error al iniciar cliente: ", err)

# Se ejecuta en el CLIENTE cuando el servidor acepta la conexión
func _al_conectar_exitoso_cliente():
	print("¡Conectado al servidor con éxito!")
	ocultar_menu()

func _al_fallar_conexion():
	print("Error: No se pudo conectar al servidor.")

# Se ejecuta en el SERVIDOR cuando un nuevo cliente entra
func _al_conectarse_jugador(id: int):
	if multiplayer.is_server():
		print("Nuevo jugador detectado con ID: ", id, ". Creando a Lili...")
		_crear_jugador(id)

func _al_desconectarse_jugador(id: int):
	if multiplayer.is_server() and has_node(str(id)):
		get_node(str(id)).queue_free()

func _crear_jugador(id: int):
	var escena = ESCENA_VAMPIRA if id == 1 else ESCENA_LILI
	var nuevo_jugador = escena.instantiate()
	nuevo_jugador.name = str(id)
	add_child(nuevo_jugador)

func ocultar_menu():
	if boton_servidor: boton_servidor.hide()
	if boton_cliente: boton_cliente.hide()
