extends Node2D

signal level_complete

@export var players_container: Node2D
@export var player_scenes: Array[PackedScene]
@export var key_door: KeyDoor

@export var spawn_points: Array[Node2D]
var next_spawn_point_index = 0
var next_character_index = 0

func _ready() -> void:
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.connect(delete_player)
	
	for id in multiplayer.get_peers():
		add_player(id)

	add_player(1)
	
	key_door.all_players_finished.connect(_on_all_players_finished)
 
func _exit_tree() -> void:
	if multiplayer.multiplayer_peer == null: return
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.disconnect(delete_player)
   
func add_player(id):
	var player_scene = get_player_scene()
	var player_instace = player_scene.instantiate()

	
	player_instace.name = str(id)
	players_container.add_child(player_instace)
	player_instace.position = get_spawn_point()
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	
	players_container.get_node(str(id)).queue_free()

func get_spawn_point():
	var spawn_point = spawn_points[next_spawn_point_index].position
	next_spawn_point_index += 1
	
	if next_spawn_point_index >= len(spawn_points):
		next_spawn_point_index = 0
	
	return spawn_point

func get_player_scene():
	var player_scene = player_scenes[next_character_index]
	next_character_index += 1
	if next_character_index >= len(player_scenes):
		next_character_index = 0
	
	return player_scene

func _on_all_players_finished():
	print("_on_all_players_finished")
	level_complete.emit()
