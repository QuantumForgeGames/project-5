extends CharacterBody2D

signal gameplay_ended


@export var animated_sprite: AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree


var previous_position


func _ready():
	previous_position = global_position
	hide()


func _process(delta):
	var direction = (global_position - previous_position).normalized()
	if direction.length() > 0:
		animated_sprite.play()
		animation_tree.get("parameters/playback").travel("walk")
		animation_tree.set("parameters/walk/blend_position", direction)
	else:
		animated_sprite.stop()
		animation_tree.get("parameters/playback").travel("RESET")

	previous_position = global_position

# TODO: Remove this
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	gameplay_ended.emit()


func start():
	show()
