extends Node2D

class_name KeyDoor

signal all_players_finished

@export var is_locked = true

@onready var door_closed: Sprite2D = $DoorClosed
@onready var door_open: Sprite2D = $DoorOpen
@onready var exit: Area2D = $Exit

var finished_players := 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !multiplayer.is_server(): return
	if !is_locked: return
	
	if area.is_in_group("key"):
		is_locked = false
		set_door_properties()
		area.get_owner().queue_free()
		exit.monitoring = true

func set_door_properties():
	door_closed.visible = is_locked
	door_open.visible = !is_locked



func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	set_door_properties()


func _on_exit_body_entered(body: Node2D) -> void:
	print("_on_exit_body_entered")
	body.queue_free()
	finished_players += 1
	if finished_players > len(multiplayer.get_peers()):
		print("all_players_finished")
		all_players_finished.emit()
