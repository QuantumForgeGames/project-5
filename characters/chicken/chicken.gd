extends Area2D

@export var SPEED: int = 200

var should_follow_player: bool = false
@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The chicken's movement vector.
	var direction = (player.global_position - position).normalized()
	print(direction)
	if should_follow_player == true:
		#var direction = (player.position - global_position).normalized()
		#var desired_velocity = direction * SPEED
		#var steering = (desired_velocity - velocity) * delta * 2.5
		#velocity += steering
		#position += velocity
		position = position.move_toward(player.global_position - (direction * 100), delta * SPEED)
		#var target_position = player.global_position - (player.global_transform.origin * 5)
		#position = position.move_toward(target_position, delta * SPEED)
		#print(player.global_position)
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * SPEED
	#position += velocity * delta


func get_angry():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color(1, .3, .3, 1), 0.25)
	tween.tween_interval(1).finished
	tween.tween_property($Sprite, "modulate", Color(1, 1, 1, 1), 1)


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.name == "Player":
		print("We are next to player")
		should_follow_player = true
