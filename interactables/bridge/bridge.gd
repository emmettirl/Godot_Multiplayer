extends Node2D

@export var required_activators = 2
@export var locked_open = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Sprite2D/StaticBody2D/CollisionShape2D

var current_activators = 0

func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	set_bridge_properties()

func set_bridge_properties():
	collision_shape_2d.set_deferred("disabled", !locked_open)
	sprite_2d.visible = locked_open
	
func activate(state):
	if !multiplayer.is_server(): return
	if state: 
		current_activators += 1
		if current_activators >= required_activators:
			locked_open = true
	else:
		current_activators -= 1
	
