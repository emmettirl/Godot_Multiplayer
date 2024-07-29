extends Node

@export var level_container: Node
@export var level_scene: PackedScene
@export var ip_line_edit: LineEdit
@export var status_label: Label

@onready var not_connected_h_box: HBoxContainer = $UI/NotConnectedHBox
@onready var host_h_box: HBoxContainer = $UI/HostHBox
@onready var ui: Control = $UI



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)


func _on_host_button_pressed() -> void:
	not_connected_h_box.hide()
	Lobby.create_game()
	host_h_box.show()
	status_label.text = "Hosting!"


func _on_join_button_pressed() -> void:
	Lobby.join_game(ip_line_edit.text)
	status_label.text = "Connecting..."
	not_connected_h_box.hide()


func _on_start_button_pressed() -> void:
	hide_menu.rpc()
	change_level.call_deferred(level_scene)

func change_level(scene):
	for c in level_container.get_children():
		level_container.remove_child(c)
		c.queue_free()
	level_container.add_child(scene.instantiate())

func _on_connection_failed():
	status_label.text = "Failed to Connect"
	not_connected_h_box.show()

func _on_connected_to_server():
	status_label.text = "Connected"

@rpc("call_local", "authority", "reliable")
func hide_menu():
	ui.hide()
	
